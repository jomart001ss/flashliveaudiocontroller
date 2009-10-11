package util 
{

	/**
	 * @author Patrick Brouwer [patrick at inlet dot nl]
	 */
	public class NumberUtils 
	{
		public static function limit(value : Number, min : Number, max : Number) : Number 
		{
			return Math.min(Math.max(min, value), max);
		}
	}
}
