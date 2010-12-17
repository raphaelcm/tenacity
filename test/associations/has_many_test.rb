require 'test_helper'

class HasManyTest < Test::Unit::TestCase

  context "An ActiveRecord class with a has_many association to a MongoMapper class" do
    setup do
      setup_fixtures
      @account = ActiveRecordAccount.create
      @person_1 = MongoMapperPerson.create
      @person_2 = MongoMapperPerson.create
      @person_3 = MongoMapperPerson.create
    end

    should "be able to set the associated objects by their ids" do
      @account.mongo_mapper_person_ids = [@person_1.id, @person_2.id, @person_3.id]
      @account.save
      assert_set_equal [@person_1, @person_2, @person_3], ActiveRecordAccount.find(@account.id).mongo_mapper_people
      assert_set_equal [@person_1.id.to_s, @person_2.id.to_s, @person_3.id.to_s], ActiveRecordAccount.find(@account.id).mongo_mapper_person_ids
    end

    context "that works with associated objects" do
      setup do
        @account.mongo_mapper_people = [@person_1, @person_2, @person_3]
        @account.save
      end

      should "be able to set the associated objects" do
        assert_set_equal [@person_1, @person_2, @person_3], ActiveRecordAccount.find(@account.id).mongo_mapper_people
      end

      should "be able to add an associated object using the << operator" do
        person_4 = MongoMapperPerson.create
        @account.mongo_mapper_people << person_4
        @account.save
        assert_set_equal [@person_1, @person_2, @person_3, person_4], ActiveRecordAccount.find(@account.id).mongo_mapper_people
      end

      should "be able to remove an associated object using the delete method" do
        @account.mongo_mapper_people.delete(@person_3)
        @account.save
        assert_set_equal [@person_1, @person_2], ActiveRecordAccount.find(@account.id).mongo_mapper_people
      end

      should "be able to clear all associated objects using the clear method" do
        @account.mongo_mapper_people.clear
        @account.save
        assert_equal [], ActiveRecordAccount.find(@account.id).mongo_mapper_people
      end
    end
  end

  context "A MongoMapper class with a has_many association to an ActiveRecord class" do
    setup do
      setup_fixtures
      @person = MongoMapperPerson.create
      @transaction_1 = ActiveRecordTransaction.create
      @transaction_2 = ActiveRecordTransaction.create
      @transaction_3 = ActiveRecordTransaction.create
    end

    should "be able to set the associated objects by their ids" do
      @person.active_record_transaction_ids = [@transaction_1.id, @transaction_2.id, @transaction_3.id]
      @person.save
      assert_set_equal [@transaction_1, @transaction_2, @transaction_3], MongoMapperPerson.find(@person.id).active_record_transactions
      assert_set_equal [@transaction_1.id, @transaction_2.id, @transaction_3.id], MongoMapperPerson.find(@person.id).active_record_transaction_ids
    end

    context "that works with associated objects" do
      setup do
        @person.active_record_transactions = [@transaction_1, @transaction_2, @transaction_3]
        @person.save
      end

      should "be able to set the associated objects" do
        assert_set_equal [@transaction_1, @transaction_2, @transaction_3], MongoMapperPerson.find(@person.id).active_record_transactions
      end

      should "be able to add an associated object using the << operator" do
        transaction_4 = ActiveRecordTransaction.create
        @person.active_record_transactions << transaction_4
        @person.save
        assert_set_equal [@transaction_1, @transaction_2, @transaction_3, transaction_4], MongoMapperPerson.find(@person.id).active_record_transactions
      end

      should "be able to remove an associated object using the delete method" do
        @person.active_record_transactions.delete(@transaction_3)
        @person.save
        assert_set_equal [@transaction_1, @transaction_2], MongoMapperPerson.find(@person.id).active_record_transactions
      end

      should "be able to clear all associated objects using the clear method" do
        @person.active_record_transactions.clear
        @person.save
        assert_set_equal [], MongoMapperPerson.find(@person.id).active_record_transactions
      end
    end
  end

end