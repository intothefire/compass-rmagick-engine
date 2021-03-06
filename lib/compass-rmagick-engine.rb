require 'RMagick'

module Compass
  module SassExtensions
    module Sprites
      class RmagickEngine < Compass::SassExtensions::Sprites::Engine

        def construct_sprite
          @canvas = Magick::Image.new(width, height)
          @canvas.background_color = 'none'
          @canvas.format = 'PNG24'
          images.each do |image|
            input_png = Magick::Image.read(image.file).first
            if image.repeat == "no-repeat"
              @canvas = composite_images(@canvas, input_png, image.left, image.top)
            else
              x = image.left - (image.left / image.width).ceil * image.width
              while x < width do
                @canvas = composite_images(@canvas, input_png, x, image.top)
                x += image.width
              end
            end
          end
          @canvas
        end 
        
        def save(filename)
          if canvas.nil?
            construct_sprite
          end
          
          canvas.write(filename)
        end
        
        private #===============================================================================>

        def composite_images(dest_image, src_image, x, y)
          width = [src_image.columns + x, dest_image.columns].max
          height = [src_image.rows + y, dest_image.rows].max
          image = Magick::Image.new(width, height) {self.background_color = 'none'}
          image.composite!(dest_image, 0, 0, Magick::CopyCompositeOp)
          image.composite!(src_image, x, y, Magick::CopyCompositeOp)
          image
        end
        
      end
    end
  end
end