RSpec.describe Event, type: :model do
    let(:event) { build(:event) }

    describe "name" do
        it "is required" do
            event.name = nil
            expect(event).to_not be_valid
        end
        it "must not exceed max length" do
            event.name = 'a' * 101
            expect(event).to_not be_valid
        end
    end

    it "is invalid with duplicate name and start_time" do
        e = create(:event)
        new_event = build(:event, name: e.name, start_time: e.start_time)
        expect(new_event).to_not be_valid
    end

    describe "creator" do
        it "creator_id is required" do
            event.creator_id = nil
            expect(event).to_not be_valid
        end
        it "must exist in users table" do
            event.creator_id = 909999999999
            expect(event).to_not be_valid
        end
    end

    it "start_time is required" do
        event.start_time = nil
        expect(event).to_not be_valid
    end

    it "end_time is required" do
        event.start_time = nil
        expect(event).to_not be_valid
    end
end
