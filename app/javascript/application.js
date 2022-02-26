// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import LocalTime from 'local-time'

LocalTime.config.i18n["fr"] = {
    date : {
        dayNames: [
            "Dimanche",
            "Lundi",
            "Mardi",
            "Mercredi",
            "Jeudi",
            "Vendredi",
            "Samedi",
        ],          
        abbrMonthNames: [
            "Jan",
            "Fév",
            "Mar",
            "Avr",
            "Mai",
            "Juin",
            "Juillet",
            "Aoüt",
            "Sep",
            "Oct",
            "Nov",
            "Déc",
        ],
        yesterday: "hier",
        today: "aujourd'hui",
        tomorrow: "demain",
        on: "le {date}",
        formats: {
            default: "%e %b %Y",
            thisYear: "%e %b",
        },
    },    
    time: {
        elapsed: "il y a {time}",
        second: "seconde",
        seconds: "secondes",
        minute: "minute",
        minutes: "minutes",
        hour: "heure",
        hours: "heures",   
        singular: "une {time}", 
        formats: {
            default: "%l:%M",
        },
    },
    datetime: {
        at: "{date} à {time}",
        formats: {
            default: "%B %e, %Y à %l:%m",
        }
    }
}
   
LocalTime.config.locale = "fr"
LocalTime.start()

