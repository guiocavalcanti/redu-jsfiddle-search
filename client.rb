$: << '.'
require 'rubygems'
require 'bundler/setup'
require 'faraday'
require 'lib/course'
require 'pp'
require 'json'
require 'yaml'

TOKEN = 'TOKENHERE'
conn = Faraday.new(:url => 'http://redu.com.br/api') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  # faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end
conn.headers = { 'Authorization' => "OAuth #{TOKEN}", 'Content-type' => 'application/json' }

course = Course.new(:course => 'pacote-web-2012-2', :connection => conn)
# students = course.students.collect do |s|
#   link = s['links'].select { |l| l['rel'] == 'user' }.first['href']
#   user = JSON.parse conn.get(link).body
#   [link, user['login']]
# end
#
# File.open('students', 'w') do |file|
#   file << Marshal::dump(students)
# end
#
# submissions = course.spaces.collect(&:submissions).flatten
# File.open('submissions', 'w') do |file|
#   file << Marshal::dump(submissions)
# end

students = Marshal::load(File.open('students'))
submissions = Marshal::load(File.open('submissions'))

def check_submission(submissions, students, link)
  html_1 = submissions.select do |s|
    s.link('statusable') == link
  end

  students.each do |s|
    pp html_1.collect { |s| s.user['login'] }.include? s[1]
  end
end

# Exercício form de cadastro
# http://www.redu.com.br/api/lectures/3000-submissao-de-projeto-formulario-de-cadastro
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3000-submissao-de-projeto-formulario-de-cadastro")

# Exercício tabela
# http://www.redu.com.br/api/lectures/3085-submissao-de-projeto-tabela
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3085-submissao-de-projeto-tabela")

# Exercicio todo1
# http://www.redu.com.br/api/lectures/3096-submissao-de-projeto-lista-de-afazeres-1
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3096-submissao-de-projeto-lista-de-afazeres-1")

# Exercicio todo2
# http://www.redu.com.br/api/lectures/3135-submissao-de-projeto-lista-de-afazeres-2
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3135-submissao-de-projeto-lista-de-afazeres-2")

# Exercicio form css
# http://www.redu.com.br/api/lectures/3149-submissao-de-projeto-formulario-com-css
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3149-submissao-de-projeto-formulario-com-css")

# Exercicio layout simples
# http://www.redu.com.br/api/lectures/3159-submissao-de-projeto-layout-simples
# check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3159-submissao-de-projeto-layout-simples")

# Exercicio layout simples
# http://www.redu.com.br/api/lectures/3163-submissao-de-projeto-layout-completo
check_submission(submissions, students, "http://www.redu.com.br/api/lectures/3163-submissao-de-projeto-layout-completo")
