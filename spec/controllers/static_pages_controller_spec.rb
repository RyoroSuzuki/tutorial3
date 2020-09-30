require 'rails_helper'
#3.4動的なページからテストはpending
RSpec.describe StaticPagesController, type: :controller do
    describe "#home" do
    #正常にレスポンスを返すこと
    it "responds successfully" do
        get :home
        expect(response).to be_success
        end
    end 

    describe "#help" do
    #正常にレスポンスを返すこと
    it "responds successfully" do
        get :help
        expect(response).to be_success
        end
    end 

    describe "#about" do
    it "responds successfully" do
        get :about
        expect(response).to be_success
        end
    end



end
