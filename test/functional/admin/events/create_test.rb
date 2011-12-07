require File.expand_path("../../../../test_helper", __FILE__)

# :stopdoc:
module Admin
  module Events
    class CreateControllerTest < ActionController::TestCase
      tests Admin::EventsController

      def setup
        super
        create_administrator_session
        use_ssl
      end

      def test_create_event
        assert_nil(Event.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')
        person = FactoryGirl.create(:person)

        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                      'promoter_id' => person.to_param, 'type' => 'SingleDayEvent'}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(skull_hollow.is_a?(SingleDayEvent), 'Skull Hollow should be a SingleDayEvent')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
        assert(flash.has_key?(:notice))

        assert_equal('Skull Hollow Roubaix', skull_hollow.name, 'name')
        assert_equal('Smith Rock', skull_hollow.city, 'city')
        assert_equal(Date.new(2010, 1, 2), skull_hollow.date, 'date')
        assert_equal('http://timplummer.org/roubaix.html', skull_hollow.flyer, 'flyer')
        assert_equal('WSBA', skull_hollow.sanctioned_by, 'sanctioned_by')
        assert_equal(true, skull_hollow.flyer_approved, 'flyer_approved')
        assert_equal('Downhill', skull_hollow.discipline, 'discipline')
        assert_equal(true, skull_hollow.cancelled, 'cancelled')
        assert_equal('KY', skull_hollow.state, 'state')
        assert_equal(person, skull_hollow.promoter, 'promoter')
      end

      def test_create_child_event
        parent = SingleDayEvent.create!
        assert_nil(Event.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')

        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                       "parent_id" => parent.to_param,
                      'promoter_id' => nate_hobson.to_param, 'type' => 'Event'}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(!skull_hollow.is_a?(SingleDayEvent), 'Skull Hollow should not be a SingleDayEvent')
        assert(skull_hollow.is_a?(Event), 'Skull Hollow should be an Event')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
        assert(flash.has_key?(:notice))

        assert_equal('Skull Hollow Roubaix', skull_hollow.name, 'name')
        assert_equal('Smith Rock', skull_hollow.city, 'city')
        assert_equal(Date.new(2010, 1, 2), skull_hollow.date, 'date')
        assert_equal('http://timplummer.org/roubaix.html', skull_hollow.flyer, 'flyer')
        assert_equal('WSBA', skull_hollow.sanctioned_by, 'sanctioned_by')
        assert_equal(true, skull_hollow.flyer_approved, 'flyer_approved')
        assert_equal('Downhill', skull_hollow.discipline, 'discipline')
        assert_equal(true, skull_hollow.cancelled, 'cancelled')
        assert_equal('KY', skull_hollow.state, 'state')
        assert_equal(nate_hobson, skull_hollow.promoter, 'promoter')
      end

      def test_create_child_for_multi_day_event
        parent = MultiDayEvent.create!
        assert_nil(SingleDayEvent.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')
        person = FactoryGirl.create(:person)

        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                       "parent_id" => parent.to_param,
                      'promoter_id' => person.to_param, 'type' => 'SingleDayEvent'}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(skull_hollow.is_a?(SingleDayEvent), 'Skull Hollow should be a SingleDayEvent')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
        assert(flash.has_key?(:notice))

        assert_equal('Skull Hollow Roubaix', skull_hollow.name, 'name')
        assert_equal('Smith Rock', skull_hollow.city, 'city')
        assert_equal(Date.new(2010, 1, 2), skull_hollow.date, 'date')
        assert_equal('http://timplummer.org/roubaix.html', skull_hollow.flyer, 'flyer')
        assert_equal('WSBA', skull_hollow.sanctioned_by, 'sanctioned_by')
        assert_equal(true, skull_hollow.flyer_approved, 'flyer_approved')
        assert_equal('Downhill', skull_hollow.discipline, 'discipline')
        assert_equal(true, skull_hollow.cancelled, 'cancelled')
        assert_equal('KY', skull_hollow.state, 'state')
        assert_equal(person, skull_hollow.promoter, 'promoter')
      end
  
      def test_create_child_event
        parent = SingleDayEvent.create!
        assert_nil(Event.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')
        person = FactoryGirl.create(:person)

        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                       "parent_id" => parent.to_param,
                      'promoter_id' => person.to_param, 'type' => ''}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(!skull_hollow.is_a?(SingleDayEvent), 'Skull Hollow should not be a SingleDayEvent')
        assert(skull_hollow.is_a?(Event), 'Skull Hollow should be an Event')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
        assert(flash.has_key?(:notice))

        assert_equal('Skull Hollow Roubaix', skull_hollow.name, 'name')
        assert_equal('Smith Rock', skull_hollow.city, 'city')
        assert_equal(Date.new(2010, 1, 2), skull_hollow.date, 'date')
        assert_equal('http://timplummer.org/roubaix.html', skull_hollow.flyer, 'flyer')
        assert_equal('WSBA', skull_hollow.sanctioned_by, 'sanctioned_by')
        assert_equal(true, skull_hollow.flyer_approved, 'flyer_approved')
        assert_equal('Downhill', skull_hollow.discipline, 'discipline')
        assert_equal(true, skull_hollow.cancelled, 'cancelled')
        assert_equal('KY', skull_hollow.state, 'state')
        assert_equal(person, skull_hollow.promoter, 'promoter')
      end

      def test_create_series
        assert_nil(Event.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')
        person = FactoryGirl.create(:person)

        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                      "promoter_id"  => person.to_param, 'type' => 'Series'}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(skull_hollow.is_a?(Series), 'Skull Hollow should be a series')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
      end

      def test_create_single_day_event
        assert_nil(Event.find_by_name('Skull Hollow Roubaix'), 'Skull Hollow Roubaix should not be in DB')
        person = FactoryGirl.create(:person)
        
        post(:create, 
             "commit"=>"Save", 
             "event"=>{"city"=>"Smith Rock", "name"=>"Skull Hollow Roubaix","date"=>"2010-01-02",
                       "flyer"=>"http://timplummer.org/roubaix.html", "sanctioned_by"=>"WSBA", "flyer_approved"=>"1", 
                       "discipline"=>"Downhill", "cancelled"=>"1", "state"=>"KY",
                      "promoter_id"  => person.to_param, 'type' => 'SingleDayEvent'}
        )
  
        skull_hollow = Event.find_by_name('Skull Hollow Roubaix')
        assert_not_nil(skull_hollow, 'Skull Hollow Roubaix should be in DB')
        assert(skull_hollow.is_a?(SingleDayEvent), 'Skull Hollow should be a SingleDayEvent')
  
        assert_redirected_to edit_admin_event_path(assigns(:event))
      end

      def test_create_from_children
        lost_child = SingleDayEvent.create!(:name => "Alameda Criterium")
        SingleDayEvent.create!(:name => "Alameda Criterium")
  
        get :create_from_children, :id => lost_child.to_param

        new_parent = MultiDayEvent.find_by_name(lost_child.name)
        assert_redirected_to edit_admin_event_path(new_parent)
      end

      def test_create_without_promoter_id
        post :create, "event"=>{"promoter_name"=>"Tour de Nuit", "city"=>"Calgary ", "name"=>"Ride the Road Tour", "date(1i)"=>"2010", "flyer_approved"=>"0", "number_issuer_id"=>"1", "sanctioned_by"=>"ABA", "date(2i)"=>"6", "notes"=>"", "pre_event_fees"=>"", "first_aid_provider"=>"", "date(3i)"=>"6", "post_event_fees"=>"", "flyer"=>"", "beginner_friendly"=>"0", "time"=>"", "instructional"=>"0", "postponed"=>"0", "team_name"=>"", "type"=>"SingleDayEvent", "phone"=>"", "practice"=>"0", "discipline"=>"", "parent_id"=>"", "cancelled"=>"0", "flyer_ad_fee"=>"", "team_id"=>"", "chief_referee"=>"", "email"=>"gary@morepeoplecycling.ca", "promoter_id"=>"", "state"=>"AB"}
  
        assert_not_nil assigns(:event), "@event"
        assert assigns(:event).errors.empty?, assigns(:event).errors.full_messages.join
        assert_redirected_to edit_admin_event_path(assigns(:event))
      end
    end
  end
end