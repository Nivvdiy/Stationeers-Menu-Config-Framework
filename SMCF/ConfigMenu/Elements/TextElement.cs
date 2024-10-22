using SMCF.ConfigMenu.Elements.Base;

namespace SMCF.ConfigMenu.Elements {
	public class TextElement : StaticElementBase{
		public TextElement(string elementName, string textLocalizationKey) : base(elementName) {
		}

		protected override void CreateElement() {
			throw new System.NotImplementedException();
		}
	}
}