class PagesController < ApplicationController
  
  def status
    @gares = Source.pluck(:gare).uniq
    @sources = Source.all
  end

  def cancelled
    @gares = Gare.pluck(:origine)
    @trains = Train.pluck(:train)
    @informations = Info.pluck(:information)
    @filters = current_user.filters

    query = "SELECT DISTINCT disturbances.* FROM disturbances WHERE disturbances.perturbation IN ('Supprimé','Supprimés')"
    
    unless params[:date].blank?
      if params[:date_fin].blank?
        query = query + " AND date = '#{ params[:date] }'" 
      else
        query = query + " AND date BETWEEN '#{ params[:date] }' AND '#{params[:date_fin]}'"
      end
    end

    if params[:source]
      @gares = current_user.sources.pluck(:gare)

      source_ids = current_user.sources.pluck(:id)
      if source_ids.any?
        query += " AND source_id IN (#{source_ids.join(', ')})"
      else
        # C'est voulu que ce soit si complexe, la query plante s'il y a rien dans le 'IN'.
        # Avec une requête en mode Rails (comme dans le controller disturbances), ça renvoie juste aucune disturbance
        query += " AND 1 = 0" # aucune ligne ne sera renvoyée
      end

    end

    if params[:gare].present?
      search = ActiveRecord::Base.connection.quote(params[:gare]) # pour éviter l'injection
      query += " AND (origine = #{search} OR destination = #{search} OR provenance = #{search})"
    end

    if params[:train].present?
      train_conditions = train_selector_to_sql(params[:train])
      if train_conditions
        query += " AND (#{train_conditions.join(' OR ')})"
      end
    end

    if params[:information].present?
      info = ActiveRecord::Base.connection.quote(params[:information])
      query += " AND information = #{info}"
    end

    if params[:filter_id].present?
      filter = Filter.find_by(id: params[:filter_id])
      if filter.user == current_user
        train_conditions = train_selector_to_sql(filter.trains)
        if train_conditions
          query += " AND (#{train_conditions.join(' OR ')})"
        end
      end
    end

    @cancelled = Disturbance.find_by_sql(query + ' ORDER BY date DESC')
    @paginatable_cancelled = Kaminari.paginate_array(@cancelled).page(params[:page]).per(100)

    respond_to do |format|
      format.html

      format.xls do
        book = CancelledToXls.new(@cancelled.first(20000), (params[:with_payload] == 'true')).call
        file_contents = StringIO.new
        book.write file_contents
        filename = 'suppressions.xls'
        send_data file_contents.string.force_encoding('binary'), filename: filename
      end
    end
  end

  def stats
    @disturbances = Disturbance.all
    @gares = Gare.pluck(:origine)
    @trains = Train.pluck(:train)
    @perturbations = Disturbance.perturbations
    @informations = Info.pluck(:information)

    if params[:source]
      @disturbances = Disturbance.where(source_id: current_user.sources.pluck(:id))
      @gares = current_user.sources.pluck(:gare)
    end

    unless params[:gare].blank?
      @disturbances = @disturbances.where("disturbances.origine = :search OR disturbances.destination = :search OR disturbances.provenance = :search", { search: params[:gare] })
    end

    unless params[:train].blank?
      ranges = params[:train].split(';').map do |range_str|
        start_str, end_str = range_str.split('-')
        start_str = start_str&.strip
        end_str = end_str&.strip
        end_str.blank? ? { single: start_str } : { range: [start_str, end_str] }
      end

      conditions = []
      values = []

      ranges.each do |entry|
        if entry[:single]
          conditions << "(disturbances.train = ?)"
          values << entry[:single]
        elsif entry[:range]
          conditions << "(disturbances.train BETWEEN ? AND ?)"
          values += entry[:range]
        end
      end

      unless conditions.empty?
        sql_condition = conditions.join(' OR ')
        @disturbances = @disturbances.where(sql_condition, *values)
      end
    end

    unless params[:perturbation].blank?
      s = "%#{params[:perturbation]}%"
      @disturbances = @disturbances.where("disturbances.perturbation LIKE ?", s)
    end

    unless params[:information].blank?
      @disturbances = @disturbances.where("disturbances.information = ?", params[:information])
    end

    unless params[:periode].blank?
      @disturbances = @disturbances.where("DATE(disturbances.created_at) BETWEEN ? AND ?", Date.today - params[:periode].to_i.days, Date.today)
    end

    @disturbances = @disturbances
                .group(:date, :train)
                .reorder(nil)
                .count(:id)
                .keys
                .sort
                .map{|key| key.first}
                .tally
  end
  
  private


  def train_selector_to_sql(trains)
    # Coupe la liste des trains en morceau et stocke chaque partie soit dans une range, soit dans une valeur
    parts = trains.split(';').map do |range_str|
      start_str, end_str = range_str.split('-')
      start_str = start_str&.strip
      end_str = end_str&.strip

      if end_str.blank? || start_str == end_str
        { single: start_str } if start_str.present?
      else
        { range: [start_str, end_str] } if start_str.present? && end_str.present?
      end
    end.compact

    # Transforme la liste des trains sélectionnés en condition SQL
    unless parts.empty?
      train_conditions = parts.map do |entry|
        if entry[:single]
          sanitized = ActiveRecord::Base.sanitize_sql_like(entry[:single])
          "train = '#{sanitized}'"
        elsif entry[:range]
          from, to = entry[:range].map { |val| ActiveRecord::Base.sanitize_sql_like(val) }
          "train BETWEEN '#{from}' AND '#{to}'"
        end
      end
      return train_conditions
    end
  end
end
