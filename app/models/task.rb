class Task < ActiveRecord::Base
	belongs_to :account
	
	#devuelve la cantidad de tareas planeadas de la cuenta y sus hijas
	def tplanbymonth(account,fini,ffin)
	  h = Hash.new
	  m = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:tplan)
	  h[:account] = account.name
	  h[:account_id] = account.id
	  h[:ene] = m['1'].to_i
	  h[:feb] = m['2'].to_i
	  h[:mar] = m['3'].to_i
	  h[:abr] = m['4'].to_i
	  h[:may] = m['5'].to_i
	  h[:jun] = m['6'].to_i
	  h[:jul] = m['7'].to_i
	  h[:ago] = m['8'].to_i
	  h[:set] = m['9'].to_i
	  h[:oct] = m['10'].to_i
	  h[:nov] = m['11'].to_i
	  h[:dic] = m['12'].to_i
	  h[:tot] = m['1'].to_i+m['2'].to_i+m['3'].to_i+m['4'].to_i+m['5'].to_i+m['6'].to_i+m['7'].to_i+m['8'].to_i+m['9'].to_i+m['10'].to_i+m['11'].to_i+m['12'].to_i
	  
	  return h
	end

	#devuelve la cantidad de tareas reales de la cuenta y sus hijas
	def trealbymonth(account,fini,ffin)
	  h = Hash.new
	  m = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:treal)
	  h[:account] = account.name
	  h[:account_id] = account.id
	  h[:ene] = m['1'].to_i
	  h[:feb] = m['2'].to_i
	  h[:mar] = m['3'].to_i
	  h[:abr] = m['4'].to_i
	  h[:may] = m['5'].to_i
	  h[:jun] = m['6'].to_i
	  h[:jul] = m['7'].to_i
	  h[:ago] = m['8'].to_i
	  h[:set] = m['9'].to_i
	  h[:oct] = m['10'].to_i
	  h[:nov] = m['11'].to_i
	  h[:dic] = m['12'].to_i
	  h[:tot] = m['1'].to_i+m['2'].to_i+m['3'].to_i+m['4'].to_i+m['5'].to_i+m['6'].to_i+m['7'].to_i+m['8'].to_i+m['9'].to_i+m['10'].to_i+m['11'].to_i+m['12'].to_i

	  return h
	end

	#devuelve la cantidad de tareas de la cuenta y sus hijas
	def hsplanbymonth(account,fini,ffin,units)
	  h = Hash.new
	  m = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:hsplan)
	  h[:account] = account.name
	  h[:account_id] = account.id
	  h[:ene] = (m['1']/units).round(1)
	  h[:feb] = (m['2']/units).round(1)
	  h[:mar] = (m['3']/units).round(1)
	  h[:abr] = (m['4']/units).round(1)
	  h[:may] = (m['5']/units).round(1)
	  h[:jun] = (m['6']/units).round(1)
	  h[:jul] = (m['7']/units).round(1)
	  h[:ago] = (m['8']/units).round(1)
	  h[:set] = (m['9']/units).round(1)
	  h[:oct] = (m['10']/units).round(1)
	  h[:nov] = (m['11']/units).round(1)
	  h[:dic] = (m['12']/units).round(1)
	  h[:tot] = ((m['1']+m['2']+m['3']+m['4']+m['5']+m['6']+m['7']+m['8']+m['9']+m['10']+m['11']+m['12'])/units).round(1)

	  return h
	end

	#devuelve la cantidad de horas reales de la cuenta y sus hijas
	def hsrealbymonth(account,fini,ffin,units)
	  h = Hash.new
	  m = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:hsreal)
	  h[:account] = account.name
	  h[:account_id] = account.id
	  h[:ene] = (m['1']/units).round(1)
	  h[:feb] = (m['2']/units).round(1)
	  h[:mar] = (m['3']/units).round(1)
	  h[:abr] = (m['4']/units).round(1)
	  h[:may] = (m['5']/units).round(1)
	  h[:jun] = (m['6']/units).round(1)
	  h[:jul] = (m['7']/units).round(1)
	  h[:ago] = (m['8']/units).round(1)
	  h[:set] = (m['9']/units).round(1)
	  h[:oct] = (m['10']/units).round(1)
	  h[:nov] = (m['11']/units).round(1)
	  h[:dic] = (m['12']/units).round(1)
	  h[:tot] = ((m['1']+m['2']+m['3']+m['4']+m['5']+m['6']+m['7']+m['8']+m['9']+m['10']+m['11']+m['12'])/units).round(1)

	  return h
	end

	def tadvancebymonth(account,fini,ffin)
	  h = Hash.new
	  m = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:treal)
	  n = Task.group('extract(month from dtask)').where(:account_id=>account.descendant_ids << account.id,:dtask=>(fini..ffin)).sum(:tplan)
	  h[:account] = account.name
	  h[:account_id] = account.id
	  if (n['1']!=0 && m['1']!=0)
		  h[:ene] = (m['1']/n['1']*100).round(0).to_s+'%'
	  else
	  	  h[:ene] = 0.to_s+'%'
	  end
	  if (n['2']!=0 && m['2']!=0)
	  	h[:feb] = (m['2']/n['2']*100).round(0).to_s+'%'
	  else
		h[:feb] = 0.to_s+'%'
	  end
	  if (n['3']!=0 && m['3']!=0)
	  	h[:mar] = (m['3']/n['3']*100).round(0).to_s+'%'
	  else
		h[:mar] = 0.to_s+'%'
	  end
	  if (n['4']!=0 && m['4']!=0)
	  	h[:abr] = (m['4']/n['4']*100).round(0).to_s+'%'
	  else
		h[:abr] = 0.to_s+'%'
	  end
	  if (n['5']!=0 && m['5']!=0)
	  	h[:may] = (m['5']/n['5']*100).round(0).to_s+'%'
	  else
		h[:may] = 0.to_s+'%'
	  end
	  if (n['6']!=0 && m['6']!=0)
	  	h[:jun] = (m['6']/n['6']*100).round(0).to_s+'%'
	  else
		h[:jun] = 0.to_s+'%'
	  end
	  if (n['7']!=0 && m['7']!=0)
	  	h[:jul] = (m['7']/n['7']*100).round(0).to_s+'%'
	  else
		h[:jul] = 0.to_s+'%'
	  end
	  if (n['8']!=0 && m['8']!=0)
	  	h[:ago] = (m['8']/n['8']*100).round(0).to_s+'%'
	  else
		h[:ago] = 0.to_s+'%'
	  end
	  if (n['9']!=0 && m['9']!=0)
	  	h[:set] = (m['9']/n['9']*100).round(0).to_s+'%'
	  else
		h[:set] = 0.to_s+'%'
	  end
	  if (n['10']!=0 && m['10']!=0)
	  	h[:oct] = (m['10']/n['10']*100).round(0).to_s+'%'
	  else
		h[:oct] = 0.to_s+'%'
	  end
	  if (n['11']!=0 && m['11']!=0)
	  	h[:nov] = (m['11']/n['11']*100).round(0).to_s+'%'
	  else
		h[:nov] = 0.to_s+'%'
	  end
	  if (n['12']!=0 && m['12']!=0)
	  	h[:dic] = (m['12']/n['12']*100).round(0).to_s+'%'
	  else
		h[:dic] = 0.to_s+'%'
	  end
	  if (n['1']+n['2']+n['3']+n['4']+n['5']+n['6']+n['7']+n['8']+n['9']+n['10']+n['11']+n['12'])!=0
	  	h[:tot] = ((m['1']+m['2']+m['3']+m['4']+m['5']+m['6']+m['7']+m['8']+m['9']+m['10']+m['11']+m['12'])/(n['1']+n['2']+n['3']+n['4']+n['5']+n['6']+n['7']+n['8']+n['9']+n['10']+n['11']+n['12'])*100).round(0).to_s+'%'
	  else
		h[:tot] = 0.to_s+'%'
	  end

	  return h
	end

	def tempty(account)
	  h = Hash.new
	  h[:account] = account.name
	  h[:account_id] = account.id
	  h[:ene] = ' '
	  h[:feb] = ' '
	  h[:mar] = ' '
	  h[:abr] = ' '
	  h[:may] = ' '
	  h[:jun] = ' '
	  h[:jul] = ' '
	  h[:ago] = ' '
	  h[:set] = ' '
	  h[:oct] = ' '
	  h[:nov] = ' '
	  h[:dic] = ' '
	  h[:tot] = ' '

	  return h
	end
end
