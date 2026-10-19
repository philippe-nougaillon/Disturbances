require 'rails_helper'

# DisturbancesDancer est défini dans app/services/disturbances_get.rb : référencer DisturbancesGet
# pour que Zeitwerk charge le fichier.
DisturbancesGet

# Rejoue DisturbancesDancer#parse sur des pages ter.sncf.com enregistrées dans
# spec/fixtures/files/ter_sncf/, sans navigateur : request_to (appel à l'API circulation-details)
# est remplacé et renvoie la charge utile passée en paramètre.
RSpec.describe DisturbancesDancer do
  include ActiveSupport::Testing::TimeHelpers

  FIXTURES = Rails.root.join('spec', 'fixtures', 'files', 'ter_sncf')

  def parse_fixture(name, source, payload: nil)
    spider = described_class.new
    allow(spider).to receive(:request_to).and_return(payload)
    html = FIXTURES.join(name).read
    silence_stdout { spider.parse(Nokogiri::HTML(html), url: source.url) }
    spider
  end

  def silence_stdout
    previous = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = previous
  end

  def source(gare, sens, slug)
    chemin = sens == 'Départ' ? 'prochains-departs' : 'prochaines-arrivees'
    Source.create!(gare: gare, sens: sens, url: "https://www.ter.sncf.com/grand-est/se-deplacer/#{chemin}/#{slug}")
  end

  around do |example|
    # Jour et heure de la capture des pages (10h30 à Paris) : les suppressions dont l'heure est
    # déjà passée sont considérées comme « du lendemain » et ne sont pas enregistrées.
    travel_to(Time.find_zone('Europe/Paris').local(2026, 10, 15, 10, 30)) { example.run }
  end

  describe 'perturbations, pages réelles du 2026-10-15' do
    it "enregistre le retard d'un « Train Fluo » au départ (Saverne)" do
      saverne = source('Saverne', 'Départ', 'saverne-87212225')
      parse_fixture('prochains-departs__saverne-87212225.html', saverne)

      expect(Disturbance.count).to eq 1
      expect(Disturbance.first).to have_attributes(
        train: '835017', sens: 'Départ', origine: 'Saverne', gare_id: 87212225, date: '2026-10-15',
        départ_prévu: '10:15', départ_réel: '10:20', départ: '10:15', destination: 'Strasbourg',
        voie: '1', perturbation: 'Retard estimé de 5 min', information: nil, source_id: saverne.id
      )
      expect(saverne.reload.collected_at).to be_present
    end

    it "enregistre le retard d'un « Train Fluo » à l'arrivée et ignore TGV INOUI et DB SNCF (Strasbourg)" do
      strasbourg = source('Strasbourg', 'Arrivée', 'strasbourg-87212027')
      parse_fixture('prochaines-arrivees__strasbourg-87212027.html', strasbourg)

      expect(Disturbance.pluck(:train)).to eq ['835017']
      perturbation = Disturbance.first
      expect(perturbation).to have_attributes(
        sens: 'Arrivée', arrivée_prévue: '10:41', arrivée: '10:41', provenance: 'Nancy',
        perturbation: 'Retard estimé de 5 min', gare_id: 87212027
      )
      expect(perturbation.voie.strip).to eq 'ND'
    end

    it "enregistre un « Train TER » modifié avec son numéro à 5 chiffres sans le « V » de « Voie » (Mulhouse)" do
      mulhouse = source('Mulhouse', 'Arrivée', 'mulhouse-87182063')
      parse_fixture('prochaines-arrivees__mulhouse-87182063.html', mulhouse)

      expect(Disturbance.pluck(:train)).to eq ['83262']
      expect(Disturbance.first).to have_attributes(
        arrivée: '10:09', provenance: 'Bantzenheim', voie: '32', perturbation: 'Modifié'
      )
    end

    it "n'enregistre rien quand la seule perturbation concerne un TGV (Metz)" do
      metz = source('Metz', 'Départ', 'metz-87192039')
      parse_fixture('prochains-departs__metz-87192039.html', metz)

      expect(Disturbance.count).to eq 0
    end

    it "complète l'information depuis l'API circulation-details" do
      saverne = source('Saverne', 'Départ', 'saverne-87212225')
      payload = [{ 'track' => '1', 'events' => [{ 'name' => 'Delay', 'duration' => 5, 'description' => 'Incident lors de la préparation du train' }] }]
      spider = parse_fixture('prochains-departs__saverne-87212225.html', saverne, payload: payload)

      expect(spider).to have_received(:request_to).with(
        :parse_repo_page,
        url: 'https://www.ter.sncf.com/api/circulation-details?number=835017&circulationDate=2026-10-15T10:15&departureStopPlaceId=87212225'
      )
      expect(Disturbance.first).to have_attributes(
        information: 'Incident lors de la préparation du train', information_payload: payload
      )
    end
  end

  describe "réponses inattendues de l'API circulation-details" do
    let(:saverne) { source('Saverne', 'Départ', 'saverne-87212225') }

    it "enregistre sans information quand l'API répond une erreur" do
      erreur = { 'statusCode' => 400, 'errorCode' => '484' }
      parse_fixture('prochains-departs__saverne-87212225.html', saverne, payload: erreur)

      expect(Disturbance.first).to have_attributes(train: '835017', information: nil, information_payload: erreur)
    end

    it "enregistre sans information quand la circulation n'a aucun évènement" do
      parse_fixture('prochains-departs__saverne-87212225.html', saverne, payload: [{ 'track' => '1', 'events' => [] }])

      expect(Disturbance.first).to have_attributes(train: '835017', information: nil)
    end
  end

  describe 'perturbations, page synthétique' do
    let(:exemple) { source('Exemple', 'Départ', 'exemple-87000000') }

    before { parse_fixture('synthetique__prochains-departs__exemple-87000000.html', exemple) }

    it 'retient les trains et tram-trains Fluo, TER et « TER Fluo », quelle que soit la casse' do
      expect(Disturbance.pluck(:train).sort).to eq %w[830012 831234 87200 88123]
    end

    it 'enregistre une suppression à venir' do
      supprimé = Disturbance.find_by(train: '831234')
      expect(supprimé).to have_attributes(perturbation: 'Supprimé', départ: '11:05', destination: 'Sélestat', information: nil)
      expect(supprimé.voie.strip).to eq 'ND'
    end

    it "ignore une suppression dont l'heure est passée (train du lendemain)" do
      expect(Disturbance.find_by(train: '831230')).to be_nil
    end

    it 'lit le numéro à 5 chiffres et la voie d’un « Train FLUO » retardé' do
      expect(Disturbance.find_by(train: '88123')).to have_attributes(
        départ_prévu: '10:40', départ_réel: '10:50', destination: 'Nancy', voie: '3', perturbation: 'Retard estimé de 10 min'
      )
    end

    it 'ignore les cars et les TGV' do
      expect(Disturbance.where(train: %w[44125 2407])).to be_empty
    end
  end

  describe 'services (départs)' do
    it 'enregistre les trains et cars Fluo comme les TER, un train retardé compris (Saverne)' do
      saverne = source('Saverne', 'Départ', 'saverne-87212225')
      parse_fixture('prochains-departs__saverne-87212225.html', saverne)

      expect(Service.count).to eq 20
      expect(Service.unscoped.group(:mode).count).to eq('Train' => 18, 'Car' => 2)
      expect(Service.find_by(numéro_service: '835017')).to have_attributes(
        horaire: '10:15', destination: 'Strasbourg', mode: 'Train', origine: 'Saverne', date: Date.new(2026, 10, 15)
      )
    end

    it 'ignore les TGV et garde les numéros à 5 chiffres (Metz)' do
      metz = source('Metz', 'Départ', 'metz-87192039')
      parse_fixture('prochains-departs__metz-87192039.html', metz)

      expect(Service.count).to eq 16
      expect(Service.where(numéro_service: %w[2807 2864 2815 9879])).to be_empty
      expect(Service.find_by(numéro_service: '88835')).to have_attributes(mode: 'Train', horaire: '10:38', destination: 'Béning-lès-Saint-Avold')
      expect(Service.where(mode: 'Car').pluck(:numéro_service).sort).to eq %w[433063 435444 44816]
    end

    it 'enregistre les tram-trains (Sarreguemines)' do
      sarreguemines = source('Sarreguemines', 'Départ', 'sarreguemines-87193615')
      parse_fixture('prochains-departs__sarreguemines-87193615.html', sarreguemines)

      expect(Service.count).to eq 20
      expect(Service.where(mode: 'TramTrain').count).to eq 8
    end

    it "n'enregistre pas de service pour une page d'arrivées" do
      strasbourg = source('Strasbourg', 'Arrivée', 'strasbourg-87212027')
      parse_fixture('prochaines-arrivees__strasbourg-87212027.html', strasbourg)

      expect(Service.count).to eq 0
    end

    it 'lit le mode, le numéro et l’horaire prévu sur la page synthétique' do
      parse_fixture('synthetique__prochains-departs__exemple-87000000.html', source('Exemple', 'Départ', 'exemple-87000000'))

      expect(Service.pluck(:numéro_service).sort).to eq %w[44125 830012 831230 831234 87200 88123 96249 TS100]
      expect(Service.find_by(numéro_service: '44125').mode).to eq 'Car'
      expect(Service.find_by(numéro_service: '87200').mode).to eq 'TramTrain'
      expect(Service.find_by(numéro_service: 'TS100').mode).to eq 'Train spécial'
      expect(Service.find_by(numéro_service: '88123')).to have_attributes(horaire: '10:40', destination: 'Nancy', mode: 'Train')
    end
  end

  describe '#parse_repo_page' do
    let(:spider) { described_class.new }
    let(:url) { 'https://www.ter.sncf.com/api/circulation-details?number=835017&circulationDate=2026-10-15T10:15&departureStopPlaceId=87212225' }

    # Chrome affiche un JSON brut dans un <pre> : c'est cette page que Tanakai transmet, en document Nokogiri.
    def page_json(json)
      Nokogiri::HTML(%(<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">#{json}</pre></body></html>))
    end

    it 'lit le JSON affiché par le navigateur' do
      réponse = spider.parse_repo_page(page_json('[{"track":"1","events":[{"description":"Incident"}]}]'), url: url)

      expect(réponse).to eq [{ 'track' => '1', 'events' => [{ 'description' => 'Incident' }] }]
    end

    it 'renvoie nil sur la page de vérification Cloudflare, en la nommant, au lieu de lever JSON::ParserError' do
      cloudflare = Nokogiri::HTML(FIXTURES.join('cloudflare__just-a-moment.html').read)
      réponse = :non_appelé

      expect { réponse = spider.parse_repo_page(cloudflare, url: url) }.to output(/Just a moment/).to_stdout
      expect(réponse).to be_nil
    end

    it 'renvoie nil sur un JSON tronqué' do
      réponse = :non_appelé

      expect { réponse = spider.parse_repo_page(page_json('[{"track":"1","events":[{"desc'), url: url) }.to output(/JSON invalide/).to_stdout
      expect(réponse).to be_nil
    end
  end
end
