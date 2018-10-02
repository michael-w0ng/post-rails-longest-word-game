require 'open-uri'
class GamesController < ApplicationController
  VOWELS = %w(a e i o u y)
  def new
    @letters = Array.new(4) { VOWELS.sample }
    @letters += Array.new(6) { (('a'..'z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @letter_check = letter_check?(@word, @letters)
    @legit_word = legit_word?(@word)

    if @letter_check && @legit_word
      @score = session[:score].nil? ? 0 : session[:score]
      @score += @word.length
      session[:score] = @score
    end
  end

  private

  def letter_check?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def legit_word?(word)
    api = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(api.read)
    json['found']
  end
end
