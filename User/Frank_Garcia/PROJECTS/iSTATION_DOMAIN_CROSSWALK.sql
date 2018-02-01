EXECUTE AS LOGIN='QueryFileUser'
GO
select distinct domain  
		,case when domain = 'adobeacres.albuquerque.nm' then '206'
			  when domain = 'alameda.albuquerque.nm' then '207'
			  when domain = 'alamosa.albuquerque.nm' then '210'
			  when domain = 'alvarado.albuquerque.nm' then '213'
			  when domain = 'anaya.albuquerque.nm' then '392'
			  when domain = 'antigua.albuquerque.nm' then '389'
			  when domain = 'apache.albuquerque.nm' then '214'
			  when domain = 'armijo.albuquerque.nm' then '215'
			  when domain = 'arroyo.albuquerque.nm' then '329'
			  when domain = 'atrisco.albuquerque.nm' then '216'
			  when domain = 'baker.albuquerque.nm' then '217'
			  when domain = 'bandelier.albuquerque.nm' then '222'
			  when domain = 'bar.albuquerque.nm' then '265'
			  when domain = 'barcelona.albuquerque.nm' then '225'
			  when domain = 'belair.albuquerque.nm' then '228'
			  when domain = 'bellehaven.albuquerque.nm' then '229'
			  when domain = 'bent.albuquerque.nm' then '230'
			  when domain = 'carson.albuquerque.nm' then '231'
			  when domain = 'chamiza.albuquerque.nm' then '295'
			  when domain = 'chaparral.albuquerque.nm' then '234'
			  when domain = 'chelwood.albuquerque.nm' then '236'
			  when domain = 'cochiti.albuquerque.nm' then '237'
			  when domain = 'colletpark.albuquerque.nm' then '240'
			  when domain = 'comanche.albuquerque.nm' then '241'
			  when domain = 'cordero.albuquerque.nm' then '395'
			  when domain = 'coronado.albuquerque.nm' then '243'
			  when domain = 'corrales.albuquerque.nm' then '351'
			  when domain = 'dennischavez.albuquerque.nm' then '203'
			  when domain = 'desertwillow.albuquerque.nm' then '900'
			  when domain = 'doloresgonzales.albuquerque.nm' then '244'
			  when domain = 'duranes.albuquerque.nm' then '249'
			  when domain = 'eagle.albuquerque.nm' then '350'
			  when domain = 'eastsanjose.albuquerque.nm' then '252'
			  when domain = 'edmund.albuquerque.nm' then '219'
			  when domain = 'edwardgonzales.albuquerque.nm' then '262'
			  when domain = 'emerson.albuquerque.nm' then '255'
			  when domain = 'eubank.albuquerque.nm' then '258'
			  when domain = 'field.albuquerque.nm' then '261'
			  when domain = 'griegos.albuquerque.nm' then '267'
			  when domain = 'hawthorne.albuquerque.nm' then '270'
			  when domain = 'hodgin.albuquerque.nm' then '273'
			  when domain = 'hughes.albuquerque.nm' then '365'
			  when domain = 'humphrey.albuquerque.nm' then '221'
			  when domain = 'inez.albuquerque.nm' then '276'
			  when domain = 'jackson.albuquerque.nm' then '420'
			  when domain = 'kirtland.albuquerque.nm' then '279'
			  when domain = 'laluz.albuquerque.nm' then '282'
			  when domain = 'lamesa.albuquerque.nm' then '285'
			  when domain = 'lavaland.albuquerque.nm' then '288'
			  when domain = 'longfellow.albuquerque.nm' then '291'
			  when domain = 'lospadillas.albuquerque.nm' then '297'
			  when domain = 'losranchos.albuquerque.nm' then '336'
			  when domain = 'lowell.albuquerque.nm' then '300'
			  when domain = 'mabinford.albuquerque.nm' then '250'
			  when domain = 'macarthur.albuquerque.nm' then '303'
			  when domain = 'marmon.albuquerque.nm' then '280'
			  when domain = 'mathesonpark.albuquerque.nm' then '305'
			  when domain = 'mccollum.albuquerque.nm' then '307'
			  when domain = 'mesa.albuquerque.nm' then '260'
			  when domain = 'missionave.albuquerque.nm' then '309'
			  when domain = 'mitchell.albuquerque.nm' then '310'
			  when domain = 'monte.albuquerque.nm' then '357'
			  when domain = 'montevista.albuquerque.nm' then '312'
			  when domain = 'montezuma.albuquerque.nm' then '315'
			  when domain = 'montoya.albuquerque.nm' then '321'
			  when domain = 'mountainview.albuquerque.nm' then '324'
			  when domain = 'navajo.albuquerque.nm' then '327'
			  when domain = 'northstar.albuquerque.nm' then '268'
			  when domain = 'okeeffe.albuquerque.nm' then '328'
			  when domain = 'onate.albuquerque.nm' then '227'
			  when domain = 'osuna.albuquerque.nm' then '332'
			  when domain = 'pajarito.albuquerque.nm' then '333'
			  when domain = 'petroglyph.albuquerque.nm' then '317'
			  when domain = 'reginaldchavez.albuquerque.nm' then '330'
			  when domain = 'rey.albuquerque.nm' then '339'
			  when domain = 'sanantonio.albuquerque.nm' then '345'
			  when domain = 'sanchez.albuquerque.nm' then '496'
			  when domain = 'sandiabase.albuquerque.nm' then '348'
			  when domain = 'sierravista.albuquerque.nm' then '356'
			  when domain = 'sky.albuquerque.nm' then '275'
			  when domain = 'sunsetview.albuquerque.nm' then '393'
			  when domain = 'tomasita.albuquerque.nm' then '363'
			  when domain = 'twain.albuquerque.nm' then '364'
			  when domain = 'vallevista.albuquerque.nm' then '370'
			  when domain = 'ventanaranch.albuquerque.nm' then '264'
			  when domain = 'wallace.albuquerque.nm' then '373'
			  when domain = 'wherry.albuquerque.nm' then '376'
			  when domain = 'whittier.albuquerque.nm' then '379'
			  when domain = 'zia.albuquerque.nm' then '385'
			  when domain = 'zuni.albuquerque.nm' then '388'
			  when domain = '' then ''
			  when domain = '' then ''
			  when domain = '' then ''
			  when domain = '' then ''
			  when domain = '' then ''
			  else 'LSJFLKSDJFLKEJRJ'

		end as loc_num


from
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM isip_results.csv'  
		)AS xyz
order by domain
REVERT
GO