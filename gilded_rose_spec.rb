require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'byebug'

describe GildedRose do
  [:update_quality, :refactored_update_quality].each do |method_name|
    describe "##{method_name}" do
      let(:sell_in) { 10 }
      let(:quality) { 40 }
      let(:item) { ItemFactory.create(item_name, sell_in, quality) }
      let(:items) { [item] }

      context 'when item is normal' do
        let(:item_name) { 'foo' }

        it 'does not change the name' do
          expect {
            GildedRose.new(items).send(method_name)
          }.not_to change { item.name }
        end

        context 'when sell_in is positive' do
          context 'when quality is positive' do
            it 'decrease quality by 1 and sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq (quality - 1)
            end
          end

          context 'when quality is zero' do
            let(:quality) { 0 }

            it 'decrease quality to 0 at most and and decrease sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq quality
            end
          end
        end

        context 'when sell_in is negative' do
          let(:sell_in) { -1 }

          context 'when quality is greater than 1' do
            it 'decrease quality by 2 and sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq (quality - 2)
            end
          end

          context 'when quality is smaller than 1' do
            let(:quality) { 1 }

            it 'decrease quality to 0 at most and and decrease sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq 0
            end
          end
        end
      end

      context 'when item is Aged Brie' do
        let(:item_name) { AgedBrieItem::NAME }

        context 'when sell_in is positive' do
          context 'when quality is smaller than 50' do
            it 'increases quantity by 1 and decreases sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq (quality + 1)
            end
          end

          context 'when quality is equal to 50' do
            let(:quality) { 50 }

            it 'keeps quality and decreases sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq quality
            end
          end
        end

        context 'when sell_in is negative' do
          let(:sell_in) { -1 }

          context 'when quality is greater than 1' do
            it 'increases quantity by 2 and decreases sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq (quality + 2)
            end
          end
        end
      end

      context 'when item is Backstage passes' do
        let(:item_name) { BackstagePassesItem::NAME }

        context 'when sell_in is positive' do
          context 'when quality is smaller than 50' do
            context 'when sell_in is greater than 10' do\
              let(:sell_in) { 11 }

              it 'increases quantity by 1 and decreases sell_in by 1' do
                GildedRose.new(items).send(method_name)
                expect(item.sell_in).to eq (sell_in - 1)
                expect(item.quality).to eq (quality + 1)
              end
            end

            context 'when sell_in is greater than 5' do
              let(:sell_in) { 6 }

              it 'increases quantity by 2 and decreases sell_in by 1' do
                GildedRose.new(items).send(method_name)
                expect(item.sell_in).to eq (sell_in - 1)
                expect(item.quality).to eq (quality + 2)
              end
            end

            context 'when sell_in is less than 5' do
              let(:sell_in) { 3 }

              it 'increases quantity by 3 and decreases sell_in by 1' do
                GildedRose.new(items).send(method_name)
                expect(item.sell_in).to eq (sell_in - 1)
                expect(item.quality).to eq (quality + 3)
              end
            end
          end

          context 'when quality is equal to 50' do
            let(:quality) { 50 }

            it 'keeps quality and decreases sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq quality
            end
          end
        end

        context 'when sell_in is negative' do
          let(:sell_in) { -1 }

          context 'when quality is greater than 1' do
            it 'sets quantity to 0 and decreases sell_in by 1' do
              GildedRose.new(items).send(method_name)
              expect(item.sell_in).to eq (sell_in - 1)
              expect(item.quality).to eq 0
            end
          end
        end
      end

      context 'when item is Sulfuras' do
        let(:item_name) { SulfurasItem::NAME }

        context 'when sell_in is positive' do
          it 'does not change quality and sell_in' do
            GildedRose.new(items).update_quality
            expect(item.sell_in).to eq sell_in
            expect(item.quality).to eq quality
          end
        end

        context 'when sell_in is negative' do
          let(:sell_in) { -1 }

          it 'does not change quality and sell_in' do
            GildedRose.new(items).update_quality
            expect(item.sell_in).to eq sell_in
            expect(item.quality).to eq quality
          end
        end
      end
    end
  end
end
