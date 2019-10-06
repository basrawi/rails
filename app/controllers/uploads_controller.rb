class UploadsController < ApplicationController

  before_action :set_upload, only: [:show, :edit, :update, :destroy]
  before_action :inhalt
  before_action :findfiles ,only: [:zeig,:index,:create ,:new]
  before_action :readfile 
  
  before_action :findefolders ,only: [:new]
 
  def index
  end


  def findfiles
     
    @files = Dir.glob("#{Rails.root}/mardowntopdf/*.txt").map{ |s| File.basename(s) }


    end

    def findefolders

      
     @folders=Dir.glob("#{Rails.root}/mardowntopdf/* ").select {|f| File.directory? f}
     if  @folders.empty?
       @folders << 'mardowntopdf'
     end
    end

def readfile

  content = File.open("#{Rails.root}/tmp/love.txt","r+")

   
end
 

def new
    #@upload = Upload.new
    #@love=@upload.params[':dir']
    respond_to do |format|
      format.js
    
    end
    
end
   
   

def chang

path = File.join Rails.root, 'mardowntopdf'

#FileUtils.mkdir_p(path) unless File.exist?(path) 
user= params[:file_name].to_s+".txt"
cont= params[:post][:body].to_s
File.open(File.join(path, user), 'w+') do |file|
#@data =  file.read
  file.puts cont
               end


  respond_to do |format|
    #format.html { render render 'show'}
     format.js
    
    end

end


  # GET /uploads/1/edit
def editfile

path = File.join Rails.root, 'mardowntopdf'  
@file=params[:name].to_s
#FileUtils.mkdir_p(path) unless File.exist?(path) 
@datei= params[:name].to_s+".txt"
File.open(File.join(path,@datei), 'r+') do |file|

@data =  file.read
#File.foreach(file).with_index do |line, line_num|
   show @data

    end

  end

  # POST /uploads
  # POST /uploads.json
  def create
    #@upload = Upload.new(upload_params)
    wo="#{Rails.root}/mardowntopdf/#{params[:file_name]}.txt"
    File.open(wo, "w+") do |f|
        f.puts  "#{params[:post][:body]}"
                   end
    respond_to do |format|

     # if @upload.save
     format.js{}
        #format.html { redirect_to @upload, notice: 'Upload was successfully created.' }
        #format.json { render :show, status: :created, location: @upload }
      #else
      #  format.html { render :new }
      #  format.json { render json: @upload.errors, status: :unprocessable_entity }
      #end
    end
  end

  


def delete

path = File.join Rails.root, 'mardowntopdf'

@file=params[:name].to_s

#FileUtils.mkdir_p(path) unless File.exist?(path) 
datei= params[:name].to_s+".txt"
#File.open(File.join(path,@datei),"r+") do |f|
 #File.delete(f)

#end
FileUtils.rm(File.join(path,datei))
end



def zeig


path = File.join Rails.root, 'mardowntopdf'

#FileUtils.mkdir_p(path) unless File.exist?(path) 
@datei= params[:name].to_s+".txt"
File.open(File.join(path,@datei), 'r') do |file|
@data =  file.read
end
#path ="#{Rails.root}/mardowntopdf/#{params[:name]}.txt}"
 
  #f = File.open(path, "r") 
  #f.each_line do |line|
  #  data += line
  #end
  #@data=File.read(,"")
  #PandocRuby.allow_file_paths = true

  
 @m2h = PandocRuby.new(@data).to_html() 
  #g=Git.open("C:/Users/lily15/git/Mandelbrot",log: Logger.new(STDOUT))

   @pars=parse(@m2h)
   @result=il_class(@pars)
   @added_line=newline(@result)
   show @added_line
   @p_in_pre=swap_p_in_pre(@added_line)
   @new_pars=add_calss_idd(@p_in_pre)


   @m2l = PandocRuby.new(@pars).to_html()
   time = Time.new
   datum= time.day.to_s+"."+time.month.to_s+"."+time.year.to_s

  
   puts "new-pras"
   show(@new_pars)

   puts "show without space"
   k=remove_space(@new_pars)

   show k
    respond_to do |format|
      format.js
    format.html {


     render :zeig ,layout: 'html'}
    format.pdf do

   
    #  @m2pdf = WickedPdf.new.pdf_from_string(@m2l,formats: :html, encoding: 'utf8', page_size: 'A4',zoom: 1,dpi:70,orientation: "landscape",
     #   header:  { line: true,center:'sssssssss',left:'Stand am:'+''+datum ,right:'NO Inhalt jetzt',:spacing => 10},
     #   footer:{line: true,content:"uni-kiel.de",right:'[page] of [topage]'},margin:{bottom:12,top:20} )
     #send_data(@m2pdf,:filename=>'test',type:'application/pdf',:disposition => 'inline',)
         

        render pdf: "Invoic",
        page_size: 'A4',
        template: "uploads/report.html.erb",
        layout: "pdf.html",
        orientation: "Landscape",
        lowquality: true,
        zoom:1.4,
        dpi: 75,
        formats: :html ,
        encoding: 'utf8' ,
        

        orientation: "landscape",
        header:  { line: true,center:'Uni-kiel',left:'Stand am:'+''+datum ,right:'NO Inhalt jetzt',:spacing => 10},
        footer:{line: true,content:"uni-kiel.de",right:'[page] of [topage]'},margin:{bottom:12,top:20} 
    end

  end
  
 
end

  def show data
    data.each_line do |word|
      puts word
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload


      @upload = Upload.find(params[:id])

      
     
    end

    
def inhalt

end

    # Never trust parameters from the scary internet, only allow the white list through.
def upload_params
  params.require(:upload).permit(:dir, :pfad, :inhalt)
end


end