using BepInEx;
using BepInEx.Logging;
using HarmonyLib;
using StationeersMods.Interface;
using System;

namespace Stationeers_Menu_Config_Framework {
	public class SmcfMod : ModBehaviour {
		private static SmcfMod _instance;
		private static object instanceLock = new();
		public static SmcfMod Instance {
			get {
				if(_instance == null) {
					lock(instanceLock) {
						if(_instance == null) {
							_instance = new SmcfMod();
						}
					}
				}

				return _instance;
			}
		}

		public override void OnLoaded(ContentHandler contentHandler) {
			try {
				Harmony harmony = new Harmony("Stationeers-Menu-Config-Framework");
				harmony.PatchAll();
			} catch(Exception e) {
				Console.WriteLine(e);
				throw;
			}
		}
	}
}