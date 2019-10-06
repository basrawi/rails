module ApplicationHelper




def set_flash(type,object:nil)

  	flash[:from]= action_name
  	flash[:type] = type
  	flash[:object_type]=object.class.name 
  	flash[:object_id] =object.id
end




class Parser 



attr_accessor  :data


	def initialize(data)

		@data=data

	end

def string_between_markers (marker1, marker2)
   self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]

  end



def sub_Absatz_index(m1 , ma2)

	      m1.gsub(/{.+}/) do |word|
		  word2=word.string_between_markers("{","}")
		  w2=ma2.to_s
		  w3=".".to_s+ma2.to_s+" ".to_s
		  dd=" ".to_s+"Absatz".to_s+w2.to_s+" ".to_s
          @data=@data.gsub(/\.{#{word2}}/,w3)
		  @data=@data.gsub(/\{#{word2}\}/,dd)


          end
end

def sub_paragraph(input , par)
        
   
        input.sub(/§§{.+}/) do |word|  



        	m=par.to_s
        	word2=word.string_between_markers("§§{","}")
        	word3=word.string_between_markers("§","}")

              
		@data=@data.gsub(/#{word}/,"§"+m+" ".to_s)
		@data=@data.gsub(/#{word3}\}/,"§"+m+" ".to_s)



	end
end

def swap_in_html_element(line)
        
   
        line.gsub(/<.+>(.?.?.?)§{.+}/) do |word|

        	w11=word.string_between_markers("<",">") 

        

        	w22=word.string_between_markers("§{","}")
        	

            o1="<".to_s + w11.to_s + "  ".to_s 
            o2= "id=".to_s + w22.to_s + ">".to_s
            o=o1.to_s + o2.to_s

		    @data=@data.gsub(/#{w11}/, o)
           
           end

end




def swap_li_html_element(line)
        
   
        line.gsub(/<.+>(.?.?.?){.+}/) do |word|

        	w11=word.string_between_markers("<",">") 

        

        	w22=word.string_between_markers("{","}")
        	

            o1="<".to_s + w11.to_s + "  ".to_s 
            o2= "id=".to_s + w22.to_s + ">".to_s
            o=o1.to_s + o2.to_s

		    @data=@data.gsub(/#{word}/, o)
           
           end

end







def parse
par=0
level=[]
idx=0 
current=0
stack=[] 



 data.each_line do |line|


if  line.match(/§§{\w+}/).present?  

     par=par+1
     swap_in_html_element(line)
	   sub_paragraph(line , par)



 elsif line.include?("<ul>")


 level[current]=idx
 current= current+1
 idx=0
 stack << "<ul>"

  
  elsif line.include?("<li>") 
        if  line.include?("</li>")
         idx=idx.to_i + 1
         puts  current.to_s+":"+idx.to_s
          puts stack.last
         if stack.last == "<ul>" and line.include?("</ul>")
          stack.pop
          level[current]=idx
	         current=current -1
           
	         
           idx=level[current]

      
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

	    
           puts stack.last
	        
    end


  elsif  line.include?("</ul>") 

    if stack.last == "<ul>"  

	    stack.pop 

         level[current]=idx
	         current=current -1
           
	         
           idx=level[current]
           if stack.empty?
           puts "empty"
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
return  data
end



end

end
