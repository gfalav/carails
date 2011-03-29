class UploadController < ApplicationController
  def index
  end

  def procesa
    rta = Array.new
    params[:archivo].read.each_line {|l|
      arrtmp = l.split(/\@|\r\n/)
      h = Hash.new
      h[:empresa]= case params[:archivo].original_filename.scan(/\_SL_|_SA_|_LR_/)[0].gsub('_','')
        when 'SL' then 'Edesal'
        when 'LR' then 'Edelar'
        when 'SA' then 'Edesa'
      end
      h[:grupo]= arrtmp[0].strip
      h[:actividad]= arrtmp[2].strip
      h[:periodo]= Date.new((arrtmp[3][0..3]).to_i,(arrtmp[3][4..5]).to_i,1)
      h[:distrito]= case (h[:empresa]+'/'+arrtmp[4].to_s.strip)
         when 'Edesal/1' then 'San Luis'
         when 'Edesal/2' then 'V. Mercedes'
         when 'Edesal/6' then 'La Toma'
         when 'Edesal/5' then 'Quines'
         when 'Edesal/4' then 'Merlo'
         when 'Edesal/7' then 'Fortuna'
         
         when 'Edelar/5' then 'Aimogasta'
         when 'Edelar/1' then 'Capital'
         when 'Edelar/2' then 'Chilecito'
         when 'Edelar/3' then 'Chepes'
         when 'Edelar/7' then 'Villa Union'
         when 'Edelar/6' then 'Chamical'         
         
         when 'Edesa/1' then 'Salta'
         when 'Edesa/2' then 'Metan'
         when 'Edesa/3' then 'Cafayate'
         when 'Edesa/4' then 'Oran'
         when 'Edesa/5' then 'Tartagal'
         when 'Edesa/6' then 'Guemes'
         when 'Edesa/7' then 'JVG'
         
         else 'No code' + '/' + h[:empresa] + '/' + arrtmp[4].to_s.strip
      end
      h[:cantidad]= arrtmp[5].to_i
      h[:hsreal]= arrtmp[6].to_i
      
      Account.where(:name=>h[:empresa]).each {|e|
         Account.where(:name=>h[:grupo],:id=>e.child_ids).each {|g|
            Account.where(:name=>h[:actividad],:id=>g.child_ids).each {|a|
               Account.where(:name=>h[:distrito],:id=>a.child_ids).each {|d|
                  act = Task.where(:account_id=>d.id,:dtask=>h[:periodo])[0]
                  act.treal = h[:cantidad]
                  act.hsreal = h[:hsreal]
                  act.save
                  rta << d.name + '/' + h[:hsreal].to_s
               }
            }
         }
      }
    }
    
    render :text=> rta.to_json
  end

end
