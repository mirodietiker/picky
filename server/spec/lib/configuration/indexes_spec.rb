# encoding: utf-8
require 'spec_helper'

describe Configuration::Indexes do
  
  before(:each) do
    @config = Configuration::Indexes.new
  end
  
  describe "types" do
    it "exists" do
      lambda { @config.types }.should_not raise_error
    end
    it "is initially empty" do
      @config.types.should be_empty
    end
  end
  
  describe "default_tokenizer" do
    it "is a default tokenizer" do
      @config.default_tokenizer.should == Tokenizers::Default::Index
    end
    it "caches" do
      @config.default_tokenizer.should == @config.default_tokenizer
    end
  end
  
  describe "delegates" do
    before(:each) do
      @receiver = mock :receiver
      @config.stub! :default_tokenizer => @receiver
    end
    it "delegates" do
      @receiver.should_receive(:removes_characters).once
      
      @config.removes_characters
    end
    it "delegates" do
      @receiver.should_receive(:contracts_expressions).once
      
      @config.contracts_expressions
    end
    it "delegates" do
      @receiver.should_receive(:stopwords).once
      
      @config.stopwords
    end
    it "delegates" do
      @receiver.should_receive(:splits_text_on).once
      
      @config.splits_text_on
    end
    it "delegates" do
      @receiver.should_receive(:normalizes_words).once
      
      @config.normalizes_words
    end
    it "delegates" do
      @receiver.should_receive(:removes_characters_after_splitting).once
      
      @config.removes_characters_after_splitting
    end
  end
  
  describe "take_snapshot" do
    before(:each) do
      @type1 = stub :type, :name => :type1
      @type2 = stub :type, :name => :type2
      
      @config.stub! :types => [@type1, @type2]
    end
    it "tells type to make a snapshot" do
      @type2.should_receive(:take_snapshot).once.with
      
      @config.take_snapshot :type2
    end
  end
  describe "index" do
    before(:each) do
      @type1 = stub :type, :name => :type1
      @type2 = stub :type, :name => :type2
      
      @config.stub! :types => [@type1, @type2]
    end
    it "tells type to index" do
      @type2.should_receive(:index).once.with
      
      @config.index :type2
    end
  end
  describe "index_solr" do
    before(:each) do
      @type1 = stub :type, :name => :type1
      @type2 = stub :type, :name => :type2
      
      @config.stub! :types => [@type1, @type2]
    end
    it "tells type to index_solr" do
      @type2.should_receive(:index_solr).once.with
      
      @config.index_solr :type2
    end
  end
  
  describe "only_if_included_in" do
    before(:each) do
      type1 = stub :type, :name => :type1
      type2 = stub :type, :name => :type2
      
      @config.stub! :types => [type1, type2]
    end
    context "without type names" do
      it "calls the block" do
        checker = stub :checker
        checker.should_receive(:bla).twice
        
        @config.only_if_included_in do |type|
          checker.bla
        end
      end
      it "calls the block" do
        checker = stub :checker
        checker.should_receive(:bla).twice
        
        @config.only_if_included_in [] do |type|
          checker.bla
        end
      end
    end
    context "with type names" do
      it "is included" do
        checker = stub :checker
        checker.should_receive(:bla).once
        
        @config.only_if_included_in [:type2, :type3, :type4] do |type|
          checker.bla
        end
      end
      it "is not included" do
        checker = stub :checker
        checker.should_receive(:bla).never
        
        @config.only_if_included_in [:type3, :type4, :type5] do |type|
          checker.bla
        end
      end
    end
  end
  
end