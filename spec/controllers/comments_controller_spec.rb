require 'spec_helper'

describe CommentsController do
  let(:app_controller) { controller }
  let(:user) { stub_model(User) }
  let(:motion) { mock_model(Motion) }
  let(:comment) { mock_model(Comment, default_motion: motion) }

  context "authenticated user" do
    before do
      sign_in user
      app_controller.stub(:authorize!).and_return(true)
      app_controller.stub(:resource).and_return(comment)
    end

    context "deleting comment" do
      it "checks permissions" do
        app_controller.should_receive(:authorize!).and_return(true)
        delete :destroy, id: 23
      end

      it "adds a message to the flash" do
        delete :destroy, id: 23
        flash[:notice].should match(/Comment deleted/)
      end

      it "redirects to the comment's motion" do
        delete :destroy, id: 23
        response.should redirect_to(motion_path(motion))
      end
    end

    context "user likes a comment" do
      before do
        comment.stub(:like)
      end

      it "checks permissions" do
        app_controller.should_receive(:authorize!).and_return(true)
        post :like, id: 23
      end

      it "adds like to comment model" do
        comment.should_receive(:like).with(user)
        post :like, id: 23
      end

      it "redirects to motion page" do
        post :like, id: 23
        response.should redirect_to(motion_url(motion))
      end
    end

    context "user unlikes a comment" do
      before do
        comment.stub(:unlike)
      end

      it "checks permissions" do
        app_controller.should_receive(:authorize!).and_return(true)
        post :unlike, id: 23
      end

      it "removes like from comment model" do
        comment.should_receive(:unlike).with(user)
        post :unlike, id: 23
      end

      it "redirects to motion page" do
        post :unlike, id: 23
        response.should redirect_to(motion_url(motion))
      end
    end
  end
end
