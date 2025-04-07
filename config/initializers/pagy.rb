# frozen_string_literal: true

# set global defaults and extra variables
# they will get merged with every new Pagy instance
Pagy::DEFAULT[:items] = 15        # items per page
Pagy::DEFAULT[:page_param] = :page # param name for the page number
Pagy::DEFAULT[:params] = { turbo_frame: "accommodations_list" } # default params for all links

# Enable the bootstrap extra
require 'pagy/extras/bootstrap'
