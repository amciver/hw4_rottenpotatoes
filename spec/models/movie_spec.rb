require "rspec"
require "spec_helper"

describe Movie do
  describe 'searching for similar movies by director' do
    it 'should call base find_all_by_director with director' do
      Movie.should_receive(:find_similar_movies_by_director).with("Aaron McIver")
      Movie.find_similar_movies_by_director('Aaron McIver')
    end
    it 'should call base find_all_by_director with director with no mock' do
      Movie.find_similar_movies_by_director('Aaron McIver')
    end
  end
  #it "should make the similar movies results available to that template"
end
