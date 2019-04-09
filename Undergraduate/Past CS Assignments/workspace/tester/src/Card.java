public class Card
{
    public enum Suit
    {
        CLUBS, DIAMONDS, HEARTS, SPADES
    }
    
    public enum Rank
    {
        TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, 
        JACK, QUEEN, KING, ACE
    }
    
    private Suit mySuit;
    private Rank myRank;
    
    public Card (Suit s, Rank r)
    {
        mySuit = s;
        myRank = r;
    }
    
    public Suit getSuit()
    {
        return mySuit;
    }
    
    public Rank getRank()
    {
        return myRank;
    }
    
    public void serRank(Rank r)
    {
        myRank = r;
    }
    
    public void setSuitAndRank(Suit s, Rank r)
    {
        mySuit = s;
        myRank = r;
    }
    
    public static void main(String[] args)
    {
        Card c1 = new Card(Card.Suit.HEARTS, Card.Rank.QUEEN);
        System.out.println(c1.getRank() + " of " + c1.getSuit());
        System.out.println(c1.myRank + " of " + c1.mySuit);
        System.exit(0);
        System.out.println(Card.Rank.QUEEN + " of " + Card.Suit.HEARTS);
    }
    
}