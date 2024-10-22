namespace SMCF.ConfigMenu.Elements.Base {
	public abstract class ElementBase {
		protected string ElementName { get; }

		protected ElementBase(string elementName) {
			ElementName = elementName;
		}

		protected abstract void CreateElement();
	}
}