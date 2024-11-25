require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_random_letters
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @included = included?(@word, @letters)
    @valid_word = valid_word?(@word)

    if !@included
      @message = "Le mot ne peut pas être créé à partir de la grille d'origine."
    elsif !@valid_word
      @message = "Le mot est valide d'après la grille, mais ce n'est pas un mot anglais valide."
    else
      @message = "Le mot est valide d'après la grille et est un mot anglais valide."
    end
  end

  private

  def generate_random_letters
    ('A'..'Z').to_a.sample(20)
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
