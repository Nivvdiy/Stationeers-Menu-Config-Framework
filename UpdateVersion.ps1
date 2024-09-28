try {
	Add-Type -AssemblyName System.Windows.Forms

	# Créer la fenêtre
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "Sélectionnez le type de version"
	$form.Size = New-Object System.Drawing.Size(300, 150)
	$form.StartPosition = "CenterScreen"

	# Créer le label
	$label = New-Object System.Windows.Forms.Label
	$label.Text = "Type de version:"
	$label.AutoSize = $true
	$label.Location = New-Object System.Drawing.Point(10, 20)
	$form.Controls.Add($label)

	# Créer le menu déroulant
	$dropdown = New-Object System.Windows.Forms.ComboBox
	$dropdown.Items.AddRange(@("major", "minor", "build"))
	$dropdown.Location = New-Object System.Drawing.Point(120, 20)
	$dropdown.Size = New-Object System.Drawing.Size(150, 20)
	$form.Controls.Add($dropdown)

	# Créer le bouton OK
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Text = "OK"
	$okButton.Location = New-Object System.Drawing.Point(50, 60)
	$okButton.Size = New-Object System.Drawing.Size(75, 23)
	$okButton.Add_Click({
		if ($dropdown.SelectedItem) {
			$global:versionType = $dropdown.SelectedItem
			$form.Close()
		} else {
			[System.Windows.Forms.MessageBox]::Show("Veuillez sélectionner un type de version.")
		}
	})
	$form.Controls.Add($okButton)

	# Créer le bouton Annuler
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Text = "Annuler"
	$cancelButton.Location = New-Object System.Drawing.Point(150, 60)
	$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
	$cancelButton.Add_Click({
		$form.Close()
	})
	$form.Controls.Add($cancelButton)

	# Afficher la fenêtre
	$form.Add_Shown({$form.Activate()})
	[void]$form.ShowDialog()

	# Vérifier si un type de version a été sélectionné
	if (-not $global:versionType) {
		Write-Host "Aucun type de version sélectionné. Script annulé."
		Read-Host -Prompt "Appuyez sur entrée pour quitter"
		exit 1
	}

	# Chemin vers le fichier .csproj
	$projectFile = "SMCF.csproj"

	# Charger le fichier .csproj avec XmlReader
	$xmlReaderSettings = New-Object System.Xml.XmlReaderSettings
	$xmlReaderSettings.IgnoreWhitespace = $true
	$xmlReader = [System.Xml.XmlReader]::Create($projectFile, $xmlReaderSettings)
	$projXml = New-Object System.Xml.XmlDocument
	$projXml.Load($xmlReader)
	$xmlReader.Close()

	# Trouver le PropertyGroup contenant la version
	$namespaceManager = New-Object System.Xml.XmlNamespaceManager($projXml.NameTable)
	$namespaceManager.AddNamespace("msb", "http://schemas.microsoft.com/developer/msbuild/2003")
	$propertyGroup = $projXml.SelectSingleNode("//msb:PropertyGroup[msb:Version]", $namespaceManager)

	if (-not $propertyGroup) {
		Write-Host "Aucun PropertyGroup contenant la version trouvé. Script annulé."
		exit 1
	}

	# Lire la version actuelle
	[Version]$currentVersion = $propertyGroup.SelectSingleNode("msb:Version", $namespaceManager).InnerText

	# Séparer la version en parties majeures, mineures et build
	$major = $currentVersion.Major
	$minor = $currentVersion.Minor
	$build = $currentVersion.Build

	# Mettre à jour la version en fonction du type de versioning
	switch ($global:versionType) {
		"major" {
			$major++
			$minor = 0
			$build = 0
		}
		"minor" {
			$minor++
			$build = 0
		}
		"build" {
			$build++
		}
	}

	# Construire la nouvelle version
	$newVersion = [Version]::New($major, $minor, $build)

	# Mettre à jour la version dans le fichier .csproj
	$propertyGroup.SelectSingleNode("msb:Version", $namespaceManager).InnerText = $newVersion

	# Préserver le formatage et les fins de ligne
	$xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
	$xmlWriterSettings.Indent = $true
	$xmlWriterSettings.NewLineHandling = "Replace"
	$xmlWriterSettings.NewLineChars = "`r`n"
	$xmlWriterSettings.IndentChars = "`t"

	$xmlWriter = [System.Xml.XmlWriter]::Create($projectFile, $xmlWriterSettings)
	$projXml.PreserveWhitespace = $true
	$projXml.Save($xmlWriter)
	$xmlWriter.Close()

	# Charger le fichier XML
	$aboutFile = "About/About.xml"
	$xmlReader = [System.Xml.XmlReader]::Create($aboutFile, $xmlReaderSettings)
	$xmldata = New-Object System.Xml.XmlDocument
	$xmldata.Load($xmlReader)
	$xmlReader.Close()

	# Mettre à jour la version dans le fichier XML
	$xmldata.SelectSingleNode("//ModMetadata/Version").InnerText = $newVersion
	$xmldata.PreserveWhitespace = $true

	$xmlWriter2 = [System.Xml.XmlWriter]::Create($aboutFile, $xmlWriterSettings)
	$xmldata.Save($xmlWriter2)
	$xmlWriter2.Close()

	# Mettre à jour la version dans SMCF.info
	$infoFile = "SMCF.info"
	$json = Get-Content $infoFile | ConvertFrom-Json 
	$json._version = $newVersion.ToString()
	$json | ConvertTo-Json | Out-File $infoFile

	Write-Output "Version mise à jour : $newVersion"
	Write-Output "Type de versioning : $versionType"
	Write-Output "Version précedente : $currentVersion"
} catch {
	Write-Output "Une erreur s'est produite : $_"
	Read-Host -Prompt "Appuyez sur entrée pour quitter"
}
