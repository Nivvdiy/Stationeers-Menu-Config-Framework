namespace SMCF.ConfigMenu.Elements.Base {
	public abstract class IntractableElementBase : ElementBase {
		protected IntractableElementBase(string elementName) : base(elementName) {
		}

		public abstract void OnValueChanged();
	}
}