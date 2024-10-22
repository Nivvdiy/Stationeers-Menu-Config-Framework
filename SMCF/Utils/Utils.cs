using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEngine;

namespace SMCF.Utils {
	public static class Utils {
		private static readonly Sprite defaultIcon;

		static Utils() {
			defaultIcon = GetIcon(typeof(Utils).Assembly.Location,"defaultIcon.png");
		}

		public static Sprite GetIcon(string modPath, string iconName) {

			string directoryPath = Path.Combine(modPath, "GameData", "Icons");
			string filePath = Path.Combine(directoryPath, iconName);
			string[]  files = [];
			string[] authorizedExt = ["png","jpg","jpeg","jpe","jfif","bmp","svg"];

			if(!Path.HasExtension(iconName) || (Path.HasExtension(iconName) && !authorizedExt.Contains(Path.GetExtension(filePath).ToLower()))) {
				string newIconName = iconName.Replace(Path.GetExtension(filePath), "");
				files = Directory.GetFiles(directoryPath, newIconName + ".*")
						.Where(f => authorizedExt.Contains(Path.GetExtension(f).ToLower()))
						.OrderBy(f => Array.IndexOf(authorizedExt, Path.GetExtension(f).ToLower()))
						.ToArray();
				filePath = files[0];
			} else  {

			}

			return null;
		}


	}
}