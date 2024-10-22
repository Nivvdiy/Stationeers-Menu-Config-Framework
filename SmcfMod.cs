using System;
using HarmonyLib;
using StationeersMods.Interface;

namespace SMCF {
	public class SmcfMod : ModBehaviour {
		private static SmcfMod _instance;
		private static readonly object InstanceLock = new();

		public static SmcfMod Instance
		{
			get
			{
				if (_instance == null) {
					lock (InstanceLock) {
						if (_instance == null) {
							_instance = new();
						}
					}
				}

				return _instance;
			}
		}

		public override void OnLoaded(ContentHandler contentHandler) {
			try {
				if (!Harmony.HasAnyPatches("Stationeers-Menu-Config-Framework")) {
					Harmony harmony = new Harmony("Stationeers-Menu-Config-Framework");
					harmony.PatchAll();
				}
			} catch (Exception e) {
				Console.WriteLine(e);
				throw;
			}
		}
	}
}