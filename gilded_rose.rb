class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.name != 'Aged Brie' and item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == 'Backstage passes to a TAFKAL80ETC concert'
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != 'Sulfuras, Hand of Ragnaros'
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != 'Aged Brie'
          if item.name != 'Backstage passes to a TAFKAL80ETC concert'
            if item.quality > 0
              if item.name != 'Sulfuras, Hand of Ragnaros'
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  def refactored_update_quality
    @items.each(&:update_quality)
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def update_quality
    adjust_quality
    update_sell_in
  end

  def update_sell_in
    self.sell_in = sell_in - 1
  end

  def adjust_quality
    new_quality = quality - 1
    new_quality -= 1 if sell_in < 0
    self.quality = [new_quality, 0].max
  end
end

class AgedBrieItem < Item
  NAME = 'Aged Brie'

  def initialize(sell_in, quality)
    super(NAME, sell_in, quality)
  end

  def adjust_quality
    new_quality = quality + 1
    new_quality += 1 if sell_in < 0
    self.quality = [new_quality, 50].min
  end
end

class SulfurasItem < Item
  NAME = 'Sulfuras, Hand of Ragnaros'

  def initialize(sell_in, quality)
    super(NAME, sell_in, quality)
  end

  def adjust_quality
  end

  def update_sell_in
  end
end

class BackstagePassesItem < Item
  NAME = 'Backstage passes to a TAFKAL80ETC concert'

  def initialize(sell_in, quality)
    super(NAME, sell_in, quality)
  end

  def adjust_quality
    if sell_in < 0
      self.quality = 0
    elsif sell_in < 6
      self.quality = [quality + 3, 50].min
    elsif sell_in < 11
      self.quality = [quality + 2, 50].min
    else
      self.quality = [quality + 1, 50].min
    end
  end
end

class ItemFactory
  def self.create(name, sell_in, quality)
    case name
    when AgedBrieItem::NAME
      AgedBrieItem.new(sell_in, quality)
    when SulfurasItem::NAME
      SulfurasItem.new(sell_in, quality)
    when BackstagePassesItem::NAME
      BackstagePassesItem.new(sell_in, quality)
    else
      Item.new(name, sell_in, quality)
    end
  end
end
