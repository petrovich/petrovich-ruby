# encoding: utf-8
require 'spec_helper'
require 'active_record'

describe "Active Record integration" do
  ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define do
    create_table :users, :force => true do |t|
      t.string :name, :surname, :patronymic
    end
  end

  ActiveRecord::Migration.verbose = true

  class User < ActiveRecord::Base
    include Petrovich::Extension

    petrovich :firstname  => :name,
              :middlename => :patronymic,
              :lastname   => :surname
  end

  context 'generated getter methods' do
    subject { User.new(:name => 'Пётр', :surname => 'Петров', :patronymic => 'Петрович') }

    its(:name_dative)       { should == 'Петру' }
    its(:surname_dative)    { should == 'Петрову' }
    its(:patronymic_dative) { should == 'Петровичу' }

    context 'does not change original attributes' do
      its(:name)       { should == 'Пётр' }
      its(:surname)    { should == 'Петров' }
      its(:patronymic) { should == 'Петрович' }
    end
  end
end