require 'spec_helper'

describe "comments/edit.html.erb" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      :new_record? => false,
      :name => "MyString",
      :email => "MyString",
      :url => "MyString",
      :body_text => "MyText",
      :entry => nil
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => comment_path(@comment), :method => "post" do
      assert_select "input#comment_name", :name => "comment[name]"
      assert_select "input#comment_email", :name => "comment[email]"
      assert_select "input#comment_url", :name => "comment[url]"
      assert_select "textarea#comment_body_text", :name => "comment[body_text]"
      assert_select "input#comment_entry", :name => "comment[entry]"
    end
  end
end
