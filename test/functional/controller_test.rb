require 'test_helper'

class ControllerTest < ActionController::TestCase
  tests WidgetsController

  setup do
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
  end

  test 'create' do
    post :create, :widget => { :name => 'Flugel' }
    widget = assigns(:widget)
    assert_equal 1, widget.versions.length
    assert_equal 153, widget.versions.last.whodunnit.to_i
    assert_equal '127.0.0.1', widget.versions.last.ip
    assert_equal 'Rails Testing', widget.versions.last.user_agent
  end

  test 'update' do
    w = Widget.create :name => 'Duvel'
    assert_equal 1, w.versions.length
    put :update, :id => w.id, :widget => { :name => 'Bugle' }
    widget = assigns(:widget)
    assert_equal 2, widget.versions.length
    assert_equal 153, widget.versions.last.whodunnit.to_i
    assert_equal '127.0.0.1', widget.versions.last.ip
    assert_equal 'Rails Testing', widget.versions.last.user_agent
  end

  test 'destroy' do
    w = Widget.create :name => 'Roundel'
    assert_equal 1, w.versions.length
    delete :destroy, :id => w.id
    widget = assigns(:widget)
    versions_for_widget = Version.with_item_keys('Widget', w.id)
    assert_equal 2,               versions_for_widget.length
    assert_equal 153,             versions_for_widget.last.whodunnit.to_i
    assert_equal '127.0.0.1',     versions_for_widget.last.ip
    assert_equal 'Rails Testing', versions_for_widget.last.user_agent
  end
end
