class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = [*?A..?Z].shuffle.take(7)
  end

  def score
    @word = params[:word]
    @token = params[:token].split("")
    array = @word.split(//)
    if english_word?(@word) == true || inclu?(@word, @token) == true
      @answer = "it is ok"
    elsif inclu?(@word, @token) == false
      @answer = "not in the grid"
    elsif english_word?(@word) == false
      @answer = "not an english word"
    else
      "bad boy"
    end
  end


  def included?(a1, a2)
    if (a1 & a2).size == a1.size
      return true
    end
  end

  def inclu?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
end

  def contains_all?(ary)
    ary.uniq.all? { |x| count(x) >= ary.count(x) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
  return json['found']
end

end
