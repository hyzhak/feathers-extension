package org.hyzhak.starling.display
{
	import flash.events.FocusEvent;
	
	import feathers.core.FeathersControl;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ControlWithBackground extends FeathersControl
	{
		/**
		 * @private
		 */
		protected var _stageTextHasFocus:Boolean = false;
		
		/**
		 * The currently selected background, based on state.
		 */
		protected var currentBackground:DisplayObject;
		
		/**
		 * @private
		 * The width of the first skin that was displayed.
		 */
		protected var _originalSkinWidth:Number = NaN;
		
		/**
		 * @private
		 * The height of the first skin that was displayed.
		 */
		protected var _originalSkinHeight:Number = NaN;

		
		public function ControlWithBackground()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);			
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			backgroundSkin.width = value;
		}
		
		override public function set height(value : Number) : void
		{
			super.height = value;
			backgroundSkin.height = value;
		}
		
		/**
		 * @private
		 */
		private var _backgroundSkin:DisplayObject;
		
		/**
		 * A display object displayed behind the header's content.
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}
		
		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}
			
			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin &&
				this._backgroundSkin != this._backgroundFocusedSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this._backgroundSkin.touchable = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		
		/**
		 * @private
		 */
		private var _backgroundFocusedSkin:DisplayObject;
		
		/**
		 * A display object displayed behind the header's content when the
		 * TextInput has focus.
		 */
		public function get backgroundFocusedSkin():DisplayObject
		{
			return this._backgroundFocusedSkin;
		}
		
		/**
		 * @private
		 */
		public function set backgroundFocusedSkin(value:DisplayObject):void
		{
			if(this._backgroundFocusedSkin == value)
			{
				return;
			}
			
			if(this._backgroundFocusedSkin && this._backgroundFocusedSkin != this._backgroundSkin &&
				this._backgroundFocusedSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundFocusedSkin);
			}
			this._backgroundFocusedSkin = value;
			if(this._backgroundFocusedSkin && this._backgroundFocusedSkin.parent != this)
			{
				this._backgroundFocusedSkin.visible = false;
				this._backgroundFocusedSkin.touchable = false;
				this.addChildAt(this._backgroundFocusedSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 * @private
		 */
		private var _backgroundDisabledSkin:DisplayObject;
		
		/**
		 * A background to display when the header is disabled.
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}
		
		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}
			
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin &&
				this._backgroundDisabledSkin != this._backgroundFocusedSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this._backgroundDisabledSkin.touchable = false;
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 * @private
		 */
		protected function refreshBackground():void
		{
			const useDisabledBackground:Boolean = !this._isEnabled && this._backgroundDisabledSkin;
			const useFocusBackground:Boolean = this._stageTextHasFocus && this._backgroundFocusedSkin;
			this.currentBackground = this._backgroundSkin;
			if(useDisabledBackground)
			{
				this.currentBackground = this._backgroundDisabledSkin;
			}
			else if(useFocusBackground)
			{
				this.currentBackground = this._backgroundFocusedSkin;
			}
			else
			{
				if(this._backgroundFocusedSkin)
				{
					this._backgroundFocusedSkin.visible = false;
					this._backgroundFocusedSkin.touchable = false;
				}
				if(this._backgroundDisabledSkin)
				{
					this._backgroundDisabledSkin.visible = false;
					this._backgroundDisabledSkin.touchable = false;
				}
			}
			
			if(useDisabledBackground || useFocusBackground)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
					this._backgroundSkin.touchable = false;
				}
			}
			
			if(this.currentBackground)
			{
				if(isNaN(this._originalSkinWidth))
				{
					this._originalSkinWidth = this.currentBackground.width;
				}
				if(isNaN(this._originalSkinHeight))
				{
					this._originalSkinHeight = this.currentBackground.height;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._originalSkinWidth;
			}
			if(needsHeight)
			{
				newHeight = this._originalSkinHeight;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		/**
		 * @private
		 */
		protected function addedToStageHandler(event:starling.events.Event):void
		{
//			this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
//			this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
		}
		
		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:starling.events.Event):void
		{
//			this.stageText.removeEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
//			this.stageText.removeEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);			
		}
		
		/**
		 * @private
		 */
		protected function stageText_focusInHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = true;
			
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 * @private
		 */
		protected function stageText_focusOutHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = false;
			
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(stateInvalid || skinInvalid)
			{
				this.refreshBackground();
			}
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
		}
	}
}