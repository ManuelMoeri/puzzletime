# frozen_string_literal: true

#  Copyright (c) 2006-2017, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.

class ErrorPageGenerator < Rails::Generators::NamedBase
  desc 'Generate a static error page based on the layout.'

  def generate_page
    error = if /^\d{3}$/.match?(file_name)
              file_name
            else
              Rack::Utils::SYMBOL_TO_STATUS_CODE[file_name.to_sym]
            end

    run "rm -f public/#{error}.html"
    request = Rack::MockRequest.env_for "/#{error}"
    request['action_dispatch.exception'] = StandardError.new 'generator'
    _, _, body = *Puzzletime::Application.call(request)
    create_file "public/#{error}.html", body.join, force: true
  end
end
