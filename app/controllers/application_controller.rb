class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 





	
protected



def string_between_markers (word,marker1, marker2)
   word[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]

 end

def addclass(line)

	s1="\"".to_s

    k=string_between_markers(line ,"," , "}")

	 "class=".to_s + s1 + k.to_s + s1 + "    ".to_s

end


def newline(date)
newdate=date
newdate.gsub(/<\/\w+>/) do |word|
	m=word.strip

	if word=="</em>" or word=="</i>" or word=="</br>"


	else
newdate=newdate.gsub(/#{m}/,"\n" + word + "\n")
end
end

return newdate
end


def sub_Absatz_index(m1 , ma2)

	      m1.gsub(/[^§]{\w+}/) do |word|
		  word2=string_between_markers(word,"{","}")
		  w2=ma2.to_s
		  w3=".".to_s+ma2.to_s+" ".to_s
		  dd=" ".to_s+"Absatz".to_s + " ".to_s + w2.to_s + ".".to_s
		  dv=" ".to_s+"Absatz".to_s + " ".to_s + w2.to_s + " ".to_s

          @data=@data.gsub(/\.{#{word2}}/,w3)
		 @data=@data.gsub(/\{#{word2}\}\./,dd)
		  @data=@data.gsub(/\{#{word2}\}/,dv)




          end
end

def sub_paragraph(input , par)
        
   
        input.sub(/§§{\w+(\,)?\w+}/) do |word|  

           puts "wordp:" + word

        	m=par.to_s
        	word3=""
            if word.index(",")
        	
        	word3=string_between_markers(word,"§",",")
        	word3=word3 +"}".to_s
        	puts "word3:" + word3

            else
        	#word2=string_between_markers(word,"§§{","}")
        	word3=string_between_markers(word,"§{","}")
        	word3="{".to_s + word3 + "}".to_s

            end
            

              
		@data=@data.gsub(/#{word}/,"§"+m+" ".to_s)
		puts @data
		@data=@data.gsub(/#{word3}/,"§"+m+" ".to_s)
		#puts @data



	end
end

def swap_in_html_element(line)
        
   
        line.gsub(/<.+>(.?.?.?)§§{\w+,\w+}/) do |word|

        	w11=string_between_markers(word,"<",">") 
        	wnew=word.match(/(?<=\<)(\s{0,3})(.*?)(?=\s)/).to_s
        	puts "#{wnew}"

            cl=""
            w22=""

           
            cl=addclass(word)
            
           

        	w22=string_between_markers(word,"§{",",")
             
        	

            o1= "<".to_s + wnew.to_s + "  ".to_s 

            s1="\"".to_s
            s2="\"".to_s
            o2= "id=".to_s + s1 + w22.to_s + s2 + "  ".to_s + cl + ">".to_s
            o=o1.to_s + o2.to_s 
            wd="<".to_s + w11 + ">".to_s
		    @data=@data.gsub(/#{wd}/, o)
           
           end

end   



def remove_space(data)
	s=""

	data.each_line do |line|

		s = s + line.strip + "\n".to_s 
	end
	return s 

	
end




def swap_li_html_element(line)
        
   
        line.gsub(/<.+>(.?.?.?){\w+}/) do |word|

        	w11=string_between_markers(word,"<",">") 

        

        	w22=string_between_markers(word,"{","}")
        	

            o1="<".to_s + w11.to_s + "  ".to_s 
            s1="\"".to_s
            s2="\"".to_s
            o2= "id=".to_s + s1 + w22.to_s + s2 + ">".to_s
            o=o1.to_s + o2.to_s

		    @data=@data.gsub(/#{word}/, o)
           
           end

end



def swap_p_in_pre(data)


@filterd=""
@new_data=data



  puts "parse started"

@new_data.each_line.with_index do |line,index|

    
       	

   if line.match(/<p>/)
   


   	  
       fd="<pre>".to_s 
        newline=line.gsub(/<p>/,fd)
       
      

    @filterd=@filterd.to_s + newline.to_s
    

elsif  line.match(/<\/p>/)

  puts "matched\p"

	      neww=line.gsub(/<\/p>/,"</pre>")
     

	      @filterd=@filterd.to_s + neww.to_s
       

 	

        	
  else
     	@filterd=@filterd.to_s + line.to_s
    


	end


end

puts "-----------------------------------------"

return @filterd

end


def add_calss_idd(line)
        
        cals_id=line
        adedd=""



        cals_id.each_line do |line|



        if line.match(/<.+>(.?.?.?){\w+,?\w*}/)
   
         line.gsub(/<.+>(.?.?.?){\w*,?\w*}/) do |word|

           puts "woooooord:#{word}"
        	w11=string_between_markers(word,"<",">") 

        	wnew=""
        	if word.match(/<\w+/).present?
        	wnew=word.match(/<\w+/).to_s
          wnew=wnew[1..wnew.length+1]
        	puts "wnew:#{wnew}"
        end  

            cl=""
            w22=""

           
            cl=addclass(word)
            
           

        	w22=string_between_markers(word,"{",",")
             
        	

            o1= "<".to_s + wnew.to_s + "  ".to_s 

            s1="\"".to_s
            s2="\"".to_s
            o2= "id=".to_s + s1 + " ".to_s + w22.to_s + s2 + cl + ">".to_s
            o=o1.to_s + o2.to_s 
            wd="<".to_s + w11 + ">".to_s
		    newline=line.gsub(/#{word}/, o)
     
		    adedd=adedd +newline.to_s
        puts"end_newadd"
           
           end
       else
       	adedd=adedd + line.to_s
         puts"-----------daded:\n"
         
        end

end
return adedd
end
















def il_class(data)

calses=[]
belegt=false
@filterd=""
@new_data=data
stack_il=[]
level=0.to_i
current_calss=""


@new_data.each_line do |line|




    if line.match(/##.*##/)
      
      puts line

        word_il=string_between_markers(line,"##","##") 
        #if word_il.index(",")
       # if word_il.index(",")
        calses=word_il.split(",")
        #first_ul_class=word_il2[0]
       # puts first_ul_class
        #secon_ul_class=word_il2[1]
        #puts secon_ul_class
        #else
        #first_ul_class=word_il
       #end
      #else 
      	#curent_class=word_il.to_s
     # end
   
      
	
   	  

    elsif  line.match("<ul>")


          if stack_il.empty?
         stack_il << "$"
         end
        stack_il << "<ul>"

         ws=calses[level]
         #if level== 0.to_i 
         #ws=first_ul_class
         #else
         #ws=secon_ul_class
         #end
            
    @filterd=@filterd.to_s + "<ul".to_s + "  ".to_s + "class=".to_s + "\"".to_s + ws.to_s + "\"".to_s + ">\n".to_s
    	     puts line
           level=level + 1
           
    elsif  line.match("</ul>")

       @filterd =@filterd.to_s + line
       puts line

       level =level -1
       stack_il.pop
       if stack_il.last == "$"
       calses=[]   
       belegt=false
       puts "finiched"
       end
        	
  else
     	@filterd=@filterd.to_s + line
       puts line


	end


end
return @filterd
puts "-----------------------------------------"
puts @filterd

end









def parse(data)
par=0
level=[]
idx=0 
current=0
stack=[] 
@data=data


 @data.each_line do |line|




 if  line.match(/§§{.+}/).present?  

     par=par+1
     swap_in_html_element(line)
	   sub_paragraph(line , par)

elsif line.match(/<ol.*?>/)


 level[current]=idx
 current= current+1
 idx=0
 if stack.empty?
 	stack << "$"
 end
 stack << "<ol>"



 elsif line.include?("<ul>")


 level[current]=idx
 current= current+1
 idx=0
 if stack.empty?
 	stack << "$"
 end
 stack << "<ul>"

  
  elsif line.include?("<li>") 


        

        if  line.include?("</li>")
         idx=idx.to_i + 1
         puts  current.to_s+":"+idx.to_s
          puts stack.last
         if stack.last == "<ul>" and line.include?("</ul>")  or stack.last == "<ol>" and line.include?("</ol>") 
          stack.pop
          level[current]=idx
	         current=current -1
           
	         
           idx=level[current]
           if stack.last == "$"
           	puts "finished"
            end
      
           end
        else

         idx=idx+1
      
         puts  current.to_s+":"+idx.to_s
         stack << "<li>"
         end
         swap_li_html_element(line)
         sub_Absatz_index(line , idx)
   elsif line.include?("</li>") 

     if stack.last == "<li>"   

	    stack.pop
           puts stack.last
	        
    end


  elsif  line.include?("</ul>") 

    if stack.last == "<ul>"  

	    stack.pop 

         level[current]=idx
	         current=current -1
           
	         
           idx=level[current]
           if stack.last == "$"
           puts "finished"
           end

	        puts stack.last
    end
elsif  line.include?("</ol>") 

    if stack.last == "<ol>"  

	    stack.pop 

         level[current]=idx
	         current=current -1
           
	         
           idx=level[current]
           if stack.last == "$"
           puts "finished"
           end

	        puts stack.last
    end

 else
 if stack.empty?
  puts "empty"
  end
 puts stack.last.to_s
 

 end

end
return  @data
end
end


























