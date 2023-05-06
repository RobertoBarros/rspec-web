require 'sinatra'

get '/' do
  # `rdbg -O -n -c -- rspec --format WebFormatter --require #{File.dirname(__FILE__)}/web_formatter.rb`
  html = `rspec --format WebFormatter --require #{File.dirname(__FILE__)}/web_formatter.rb`
  remove_text_around_html_tags(html)
end

private

def remove_text_around_html_tags(input_string)
  # Use expressão regular para encontrar as posições das tags <html> (com ou sem atributos) e </html>
  start_pos = input_string.index(/<html[^>]*>/i)
  end_pos = input_string.index(/<\/html>/i)

  # Caso não encontre ambas as tags, retorne a string original
  return input_string if start_pos.nil? || end_pos.nil?

  # Adicione o comprimento da tag <html (com ou sem atributos)> para incluir a própria tag no resultado
  start_pos += input_string[start_pos..-1].index(/>/) + 1

  # Adicione 8 à posição inicial da tag </html> para incluir a própria tag no resultado
  end_pos += 7

  # Remova o texto antes e depois das tags, retornando o resultado
  input_string[start_pos..end_pos]
end
