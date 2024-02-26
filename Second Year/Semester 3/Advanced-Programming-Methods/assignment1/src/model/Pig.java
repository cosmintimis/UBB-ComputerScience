package model;

public class Pig implements Animal
{
    private float weight;
    private String name;
    public Pig(int weight, String name)
    {
        this.weight = weight;
        this.name = name;
    }
    public float getWeight()
    {
        return this.weight;
    }
    public void setWeight(float weight)
    {
        this.weight = weight;
    }
    public void setName(String name)
    {
        this.name = name;
    }
    public String getName()
    {
        return this.name;
    }
    public String toString()
    {
        return name + " has " + weight + "kg";
    }
}
