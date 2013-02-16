﻿package playerio{	/**	 * Provides access to the PayVault service provided by Player.IO. 	 * 	 */	public interface PayVault{		/**		 * The current coin balance the users PayVault. Can only be read after a successful call of refresh(). 		 * @return coins		 * 		 */		function get coins():int		/**		 * All the items currently in the users PayVault. Can only be read after a successful call of refresh(). 		 * @return items		 * 		 */		function get items():Array		/**		 * Does the vault contain at least on item of the given type (itemKey)? 		 * @param The itemKey to check for. 		 * @return true if the user has at least one item of the given type (itemKey)		 * 		 */		function has(itemKey:String):Boolean		/**		 * Get the first item of the given type (itemKey)		 * @param The itemKey of the item to get		 * @return The first instance of VaultItem that matches itemKey if we have any.		 * 		 */		function first(itemKey:String):VaultItem		/**		 * How many items of the given type (itemKey) does the user has in the vault? 		 * @param The itemKey of the items to count		 * @return The number of items of the given type that the user has in the vault		 * 		 */		function count(itemKey:String):uint		/**		 * Refreshes the Items and Coins from the PayVault. 		 * @param callback method called when request where successful		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function refresh(callback:Function=null, errorHandler:Function=null):void		/**		 * Load a page of entries from the users PayVault history in reverse chronological order.		 * @param page The id of the page to load. The first page is id 1.		 * @param pageSize The amount of entries for each page.		 * @param callback method called when request where successful. An array if PayVaultHistoryEntry elements is returned to the callback function(history:Array){...}		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function readHistory(page:uint, pageSize:uint, callback:Function=null, errorHandler:Function=null):void		/**		 * Put coins into the users vault		 * @param amount The amount of coins to put into the users vault.		 * @param reason Any string you'll later wish to retrieve with the ReadHistory() method.		 * @param callback method called when request where successful.		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function credit(amount:uint, reason:String, callback:Function=null, errorHandler:Function=null):void		/**		 * Take coins out of the users vault		 * @param amount The amount of coins to take out of the users vault.		 * @param reason Any string you'll later wish to retrieve with the ReadHistory() method.		 * @param callback method called when request where successful.		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function debit(amount:uint, reason:String, callback:Function=null, errorHandler:Function=null):void		/**		 * Consume items from the users vault. This will cause them to be removed from the users vault.		 * @param items The items to use from the users vault - this should be instances from the .Items array property.		 * @param callback method called when request where successful.		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function consume(items:Array, callback:Function=null, errorHandler:Function=null):void		/**		 * Buy items with coins. 		 * @param items Each BuyItemInfo instance contains the key of the item to buy in the PayVaultItems BigDB table and any additional payload.		 * @param storeItems If true, the items will be stored in the users vault, if false, it's the same as using an item directly after purchase.		 * @param callback method called when request where successful.		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function buy(items:Array, storeItems:Boolean, callback:Function=null, errorHandler:Function=null):void		/**		 * Give the user items without taking any of his coins from the vault.		 * @param items Each BuyItemInfo instance contains the key of the item to give in the PayVaultItems BigDB table and any additional payload.		 * @param callback method called when request where successful.		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function give(items:Array, callback:Function=null, errorHandler:Function=null):void		/**		 * Gets information about how to make a direct item purchase with the specified PayVault provider.		 * @param provider The name of the PayVault provider to use for the coin purchase.		 * @param purchaseArguments Any additional information that will be given to the PayVault provider to configure this purchase.		 * @param items Each BuyItemInfo instance contains the key of the item to buy and any additional payload.		 * @param callback method called when request where successful. An object with provider specific arguments are returned to the callback. function(o:Object){...}		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function getBuyDirectInfo(provider:String, purchaseArguments:Object, items:Array, callback:Function=null, errorHandler:Function=null):void		/**		 * Gets information about how to make a coin purchase with the specified PayVault provider.		 * @param provider Gets information about how to make a coin purchase with the specified PayVault provider.		 * @param purchaseArguments Any additional information that will be given to the PayVault provider to configure this purchase.		 * @param callback method called when request where successful. An object with provider specific arguments are returned to the callback. function(o:Object){...}		 * @param errorHandler method called if an error occurs during the refresh.		 * 		 */		function getBuyCoinsInfo(provider:String, purchaseArguments:Object, callback:Function=null, errorHandler:Function=null):void		/**		 * --		 * @param provider --		 * @param providerArguments --		 * @param callback --		 * @param errorHandler --		 * 		 */		function usePaymentInfo(provider:String, providerArguments:Object, callback:Function=null, errorHandler:Function=null):void			}	}