namespace SMCF.Utils {
	public class Logger {
		private static Logger _instance;
		private static readonly object InstanceLock = new();

		public static Logger Instance {
			get {
				if(_instance == null) {
					lock(InstanceLock) {
						if(_instance == null) {
							_instance = new();
						}
					}
				}

				return _instance;
			}
		}
	}
}