using SMCF.ConfigMenu.Elements;
using SMCF.SMCF.ConfigMenu.Elements;
using UnityEngine;

namespace SMCF.ConfigMenu
{
    public class ModConfig {

		private ModButton _modButton;
		private Page _page;
		private Sprite _iconSprite;
		private string _modName;

		public ModConfig(string modName, string path, string iconFileName) {
			this._modName = modName;
			_iconSprite = Utils.Utils.GetIcon(path, iconFileName);
		}

		public void Generate() {

		}

		public Section AddSection(string sectionName) {
			return new Section();
		}

	}
}