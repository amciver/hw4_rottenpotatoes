require "rspec"
require "spec_helper"

describe MoviesController do
  describe "searching for similar movies by director" do
    it "should call the model method that provides similar movies by director" do
      Movie.should_receive(:find_similar_movies_by_director).with("Aaron McIver")
      Movie.find_similar_movies_by_director("Aaron McIver")
    end
    it "should select the Similar Movies template for rendering when movies exist" do
      fake_movie = mock('movie', :title => "Movie 1", :director => "Aaron McIver")
      fake_results = [mock('movie', :title => "Movie 1", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver")]
      Movie.stub(:find_by_title).and_return(fake_movie)
      Movie.stub(:find_similar_movies_by_director).and_return(fake_results)
      get :find_similar, {:title => "Fake Movie"}
      response.should render_template('find_similar')
    end
    it "should make the similar movies results available to that template" do
      fake_movie = mock('movie', :title => "Movie 1", :director => "Aaron McIver")
      fake_results = [mock('movie', :title => "Movie 1", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver")]
      Movie.stub(:find_by_title).and_return(fake_movie)
      Movie.stub(:find_similar_movies_by_director).and_return(fake_results)
      get :find_similar, {:title => "Fake Movie"}
      assigns(:movies).should == fake_results
    end
    it "should redirect to the Movies home page when movies do not exist" do
      fake_movie = mock('movie', :title => "Movie 1", :director => "")
      fake_results = []
      Movie.stub(:find_by_title).and_return(fake_movie)
      Movie.stub(:find_similar_movies_by_director).and_return(fake_results)
      get :find_similar, {:title => "Fake Movie"}
      response.should redirect_to(movies_path)
    end
  end
  describe "viewing movies on home page" do
    it "should provide a listing of all movies with no ratings selected" do
      fake_movies = [mock('movie', :title => "Movie 1", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver"), mock('movie', :title => "Movie 3", :director => "Aaron McIver")]
      Movie.stub(:find_all_by_ratings).and_return(fake_movies)
      post :index
    end
    it "should provide a list of all movies with sorting by title" do
      fake_movies = [mock('movie', :title => "Movie 1", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver"), mock('movie', :title => "Movie 3", :director => "Aaron McIver")]
      Movie.stub(:find_all_by_ratings).and_return(fake_movies)
      post :index, {:sort => "title"}
    end
    it "should provide a list of all movies with sorting by release date" do
      fake_movies = [mock('movie', :title => "Movie 1", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver"), mock('movie', :title => "Movie 3", :director => "Aaron McIver")]
      Movie.stub(:find_all_by_ratings).and_return(fake_movies)
      post :index, {:sort => "release_date"}
    end
    it "should provide a list of all movies with sorting by rating when rating is 'G', 'PG'" do
      fake_movies = [mock('movie', :title => "Movie 1", :rating => "G", :director => "Aaron McIver"), mock('movie', :title => "Movie 2", :director => "Aaron McIver"), mock('movie', :title => "Movie 3", :director => "Aaron McIver")]
      Movie.stub(:find_all_by_ratings).and_return(fake_movies)
      post :index, {:ratings => %w(G PG)}
    end
  end
  describe "creating a new movie" do
       it "should call the model method to create a new movie" do
         fake_movie = mock('movie', :title => "Movie 1", :director => "Aaron McIver")
         Movie.stub(:create!).and_return(fake_movie)
         put :create, {:movie => "Movie 1"}
         assigns(:movie).should == fake_movie
         response.should redirect_to(movies_path)
       end
  end
  describe "updating a movies contents" do
    it "should call the model method to update the movies attributes" do
      movie = Movie.create(:title => "Movie 1", :director => "Aaron McIver")
      Movie.stub(:find).and_return(movie)
      put :update, {:id => movie.id}
      assigns(:movie).should == movie
      response.should redirect_to(movie_path(movie))
    end
  end

  describe "deleting a movie" do
    it "should call destroy on the model to remove it" do
      movie = Movie.create(:title => "Movie 1", :director => "Aaron McIver")
      Movie.stub(:find).and_return(movie)
      delete :destroy, {:id => movie.id}
      response.should redirect_to(movies_path)
    end
  end
end
