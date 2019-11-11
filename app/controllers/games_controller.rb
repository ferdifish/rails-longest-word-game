require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @status = params[:status]
    # @session_id = params[:session_id]

    if english_word(@word) && word_in_grid(@word, @grid)
      @score = @word.length + 100
      @message = "Congratulations! #{@word.upcase} is a valid word!"
      if session[:score].nil?
        session[:score] = @score
      else
        session[:score] += @score
      end

    elsif english_word(@word) != true
      @message = 'Sorry, that word is not an english word.'
    elsif word_in_grid(@word, @grid) != true
      @message = "Sorry, that word can't be built out of these letters."
    end

    session[:score] = nil if @status == true
  end

  def english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found'] == true
  end

  def word_in_grid(word, grid)
    letters = word.upcase.chars
    letters.all? { |letter| grid.split.count(letter) >= letters.count(letter) }
  end
end
