# encoding: utf-8
require 'spec_helper'

describe Petrovich::Rules do
  subject { Petrovich::Rules.new(:male) }

  it {
    expect { subject.send(:find_for, 'Хэмингуэй', Petrovich::RULES['lastname']) }.to raise_error(Petrovich::UnknownRuleException)
  }

  it { subject.send(:find_and_apply, 'Хэмингуэй', :dative, Petrovich::RULES['lastname']) == 'Хэмингуэй' }
end