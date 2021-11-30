using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

public class PluginHelper : MonoBehaviour
{
    [SerializeField] private Text textResult;
    public InputField firstName;
    public InputField FamilyName;

    [DllImport("__Internal")]
    //private static extern void IOSdirectlyAddContact(string firstName,string lastName, string Email, string Phone);
    private static extern void IOSaddContact(string firstName, string lastName, string Email, string Phone);
    void Start()
    {
       
    }

    public void AddContact()
    {
        // IOSdirectlyAddContact(firstName.text,FamilyName.text,"0","0");
        IOSaddContact(firstName.text, FamilyName.text, "0", "0");
    }
}