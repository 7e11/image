require "rubygems" #import rubygems, allows me to import rmagick gem
require "RMagick"  #import the rmagick gem.
include Magick     #include rmagick in the global namespace.

#End Requires / Includes

#Begin patching String class.

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m" #ansi sequence that colors text.
  end
  
  #All base colors:

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end
  
  def rainbow
    colorize(rand(5) + 31)
  end  

  def superRainbow
    #TODO: Probalby should have used String.each_char...
    strArr = self.split("")
    colStrArr = []
    strArr.each do |letter|
      colStrArr.push(letter.rainbow)    
    end
    return colStrArr.join
    #Sigh, spent 30 minutes on this method to use it once...    
  end
end

#No Methods.

#Vars:

inputQuit = "n"

#End Vars

#Begin Main Program:

puts "THIS PROGRAM EDITS IMAGES".superRainbow
puts "NOTE: Continuing to select effects will apply them to the edited image".yellow
 
while true
  puts "WARNING: Image must be in current dir".yellow
  puts "Please enter the name of the image you want to edit.".rainbow
  inputImageName = gets.chomp
  break if (File.exists?(inputImageName.to_s))
end

inputImage = ImageList.new(inputImageName.to_s)
puts "#{inputImageName} Found!".green
puts "What would you like to edit?".rainbow

while true
  while true
    puts "You can - blur, flip, invert, rotate, charcoal, oilpaint, sepiatone, pixel, rand, threshold, dither, rblur, shade, sketch, spread, vignette and grey".green
    puts "You can write to a file with - write".green
    puts "You can also close the program with - quit".green
    userEditSel = gets.chomp
    break if (userEditSel == "spread" || userEditSel == "blur" || userEditSel == "flip" || userEditSel == "invert" || userEditSel == "rotate" || userEditSel == "quit" || userEditSel == "write" || userEditSel == "charcoal" || userEditSel == "oilpaint" || userEditSel == "sepiatone" || userEditSel == "gray" || userEditSel == "pixel" || userEditSel == "rand" || userEditSel == "threshold" || userEditSel == "dither" || userEditSel == "rblur" || userEditSel == "shade" || userEditSel == "sketch" || userEditSel == "vignette")
  end

  #Don't reinvent the wheel...
  if (userEditSel == "blur")
    inputImage = inputImage.blur_image(0.0,5.0)
    puts "Applied minior blur to: #{inputImageName}".yellow
  elsif (userEditSel == "flip")
    inputImage = inputImage.flop
    puts "Applied vertical flip to: #{inputImageName}".yellow
  elsif (userEditSel == "invert")
    inputImage = inputImage.negate
    puts "Applied invert colors to: #{inputImageName}".yellow
  elsif (userEditSel == "rotate")
    print "How many degrees would you like to rotate: ".rainbow
    rotateAmmount = gets.chomp
    inputImage = inputImage.rotate(rotateAmmount.to_f)
    puts "Applied rotate(#{rotateAmmount}) to: #{inputImageName}"
    puts "Rotated #{inputImageName} #{rotateAmmount} degrees".yellow
  elsif (userEditSel == "charcoal")
    inputImage = inputImage.charcoal
    puts "Applied charcol effect to: #{inputImageName}".yellow
  elsif (userEditSel == "oilpaint")
    inputImage = inputImage.oil_paint(6)
    puts "Applied oil effect to: #{inputImageName}".yellow
  elsif (userEditSel == "sepiatone")
    inputImage = inputImage.sepiatone
    puts "Applied sepiatone effect to: #{inputImageName}".yellow
  elsif (userEditSel == "gray")
    inputImage = inputImage.quantize(256, GRAYColorspace)
    puts "Applied grayscale effect to: #{inputImageName}".yellow
  elsif (userEditSel == "pixel")
    inputImage = inputImage.scale(0.1).scale(10)
    puts "Applied Pixelate effect to: #{inputImageName}".yellow
  elsif (userEditSel == "rand")
    inputImage = inputImage.add_noise(PoissonNoise) #Using poisson noise because random destroys the image.
    puts "Added poisson noise to: #{inputImageName}".yellow
  elsif (userEditSel == "threshold")
    inputImage = inputImage.adaptive_threshold
    puts "Applied threshold effect to: #{inputImageName}".yellow
  elsif (userEditSel == "dither")
    inputImage = inputImage.ordered_dither
    puts "Applied dither effect to #{inputImageName}".yellow
  elsif (userEditSel == "rblur")
    inputImage = inputImage.radial_blur(10.0)
    puts "Applied radial blur effect to #{inputImageName}".yellow
  elsif (userEditSel == "shade")
    inputImage = inputImage.shade(true, 50, 50)
    puts "Applied shade effect to #{inputImageName}".yellow
  elsif (userEditSel == "sketch")
    puts "Apply sketch in full color? (y/n)".rainbow
    sketchCol = gets.chomp
    unless (sketchCol == "y")
      inputImage = inputImage.quantize(256, GRAYColorspace)
    end
    #Histogram Equalization
    sketchInputImage = inputImage.equalize
    #Apply sketch effect, then blend back in 25% of the origin image.
    sketchInputImage = sketchInputImage.sketch(0, 10, 135)
    inputImage = inputImage.dissolve(sketchInputImage, 0.75, 0.25)
    puts "Applied sketch effect to #{inputImageName}".yellow    
  elsif (userEditSel == "spread")
    inputImage = inputImage.spread
    puts "Applied spread effect to #{inputImageName}".yellow
  elsif (userEditSel == "vignette")
    inputImage = inputImage.vignette
    puts "Applied vignette effect to #{inputImageName}".yellow
  elsif (userEditSel == "write")
    puts "WARNING: DO NOT end your name with .png or .jpeg etc.".yellow
    print "Name your image: ".rainbow
    imgName = gets.chomp
    inputImage.write(ENV['HOME'] + "/public_html/#{imgName}.png")
    puts "Created #{imgName} in public_html dir".rainbow
  elsif (userEditSel == "quit")
    exit  
  end
end
#TODO: all of these features
=begin
Ok, first what needs to happen is that you need to get RMagick.
You also need to get the image that RMagick will be working on.
The implement several different methods that will change the photo
These methods will be:
1. Blur: Allready implemented into the program.
2. Miniize: Done
3. Mirror: This should take each line of the images, shift from it, and push that onto another array.Then create an image off of the new arrays.
4. Rand: This should go through each pixel of the image amd run code which alteres either the r,g,b channel. And either increasees or decreases it.
5. PhotoNeg: This should take the image, and rubtract the rgb of the image from the maximum rgb that is possible.
6. Rotate: Learn about 2d matrixis. or just use the built in rotate method.
7. Merge?: Create a method that allows the user to merge thei	r image with another.
	1. Create it so that every other pixel is swapped.
	2. This would need for the images to be the same resolution, or to be edited to the same resolution.
8. Animate?: Allow the user to create a gif of several images.
NEXT: Ask the uses if they want to use the new image they had just creaed, or the origional image.

FEATURE: Create a list of the applied edits they have to their image and in the order they are in.

FEATURE: When the user is finnished, automaticly move the image to their public html directory under their custom name.

FEATURE: Ask the user what filetype they want their image in. Let the user know about the behnefits of different filetypes.
=end

