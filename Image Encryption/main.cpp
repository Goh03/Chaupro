#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <bitset>
#include <algorithm>
#include "opencv2/opencv.hpp"
// #include "BST.cpp"

using namespace std;

struct node
{
    string data;
    node* left;
    node* right;

    ~node()
    {
        delete left;
        delete right;
    }
};

string convertToBinary(const cv::Mat& image)
{
    string binaryString;
    for (int i = 0; i < image.rows; ++i)
    {
        for (int j = 0; j < image.cols; ++j)
        {
            uchar pixelValue = image.at<uchar>(i, j);
            string binaryValue = bitset<8>(pixelValue).to_string();
            binaryString += binaryValue;
        }
    }
    return binaryString;
}

void saveBinaryStringToFile(const string& binaryString, const string& outputFilePath)
{
    ofstream outputFile(outputFilePath);
    if (outputFile.is_open())
    {
        outputFile << binaryString;
        outputFile.close();
        cout << "Binary string saved to " << outputFilePath << endl;
    }
    else
    {
        cerr << "Unable to open the output file." << endl;
    }
}

node* makeNode(const string& data)
{
    node* newNode = new node();
    newNode->data = data;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}

node* Insert(node*& root, const string& data)
{
    if (root == NULL)
    {
        root = makeNode(data);
    }
    else if (data <= root->data)
    {
        root->left = Insert(root->left, data);
    }
    else
    {
        root->right = Insert(root->right, data);
    }
    return root;
}

bool Search(const node* root, const string& data)
{
    if (root == NULL)
        return false;
    else if (root->data == data)
        return true;
    else if (data <= root->data)
        return Search(root->left, data);
    else
        return Search(root->right, data);
}

int FindHeight(const node* root)
{
    if (root == NULL)
        return -1;
    return max(FindHeight(root->left), FindHeight(root->right)) + 1;
}

node* FindMin(node* root)
{
    while (root->left != NULL)
    {
        root = root->left;
    }
    return root;
}

node* FindMax(node* root)
{
    while (root->right != NULL)
    {
        root = root->right;
    }
    return root;
}

node* Delete(node*& root, const string& data)
{
    if (root == NULL)
        return root;
    else if (data < root->data)
        root->left = Delete(root->left, data);
    else if (data > root->data)
        root->right = Delete(root->right, data);
    else if (data == root->data)
    {
        // No child
        if (root->left == NULL && root->right == NULL)
        {
            delete root;
            root = NULL;
        }
        // 1 chilđ
        else if (root->left == NULL)
        {
            node* temp = root;
            root = root->right;
            delete temp;
        }
        else if (root->right == NULL)
        {
            node* temp = root;
            root = root->left;
            delete temp;
        }
        // 2 children
        else
        {
            node* temp = FindMin(root->right);
            root->data = temp->data;
            root->right = Delete(root->right, temp->data);
        }
    }
    return root;
}

void traversal_inorder(const node* root)
{
    if (root == NULL)
        return;
    traversal_inorder(root->left);
    cout << root->data << " ";
    traversal_inorder(root->right);
}

void traversal_preorder(const node* root)
{
    if (root == NULL)
        return;
    cout << root->data << " ";
    traversal_preorder(root->left);
    traversal_preorder(root->right);
}

void traversal_postorder(const node* root)
{
    if (root == NULL)
        return;
    traversal_postorder(root->left);
    traversal_postorder(root->right);
    cout << root->data << " ";
}

void store_inorder(const node* root, vector<string>& sortedArray)
{
    if (root == NULL)
        return;
    store_inorder(root->left, sortedArray);
    sortedArray.push_back(root->data);
    store_inorder(root->right, sortedArray);
}

node* BuildBalancedBST(const vector<string>& sortedArray, int start, int end)
{
    if (start > end)
        return NULL;
    int mid = (start + end) / 2;
    node* newNode = makeNode(sortedArray[mid]);
    newNode->left = BuildBalancedBST(sortedArray, start, mid - 1);
    newNode->right = BuildBalancedBST(sortedArray, mid + 1, end);
    return newNode;
}

node* BalanceTree(node* root)
{
    vector<string> sortedArray;
    store_inorder(root, sortedArray);
    return BuildBalancedBST(sortedArray, 0, sortedArray.size() - 1);
}

string binaryToATGC(const string& binaryString)
{
    string atgcString;
    size_t length = binaryString.length();

    if (length % 8 != 0)
    {
        cerr << "Invalid binary string length. Length must be a multiple of 8." << endl;
        return atgcString;
    }

    for (size_t i = 0; i < length; i += 2)
    {
        string nucleotide;

        if (binaryString[i] == '0')
        {
            if (binaryString[i + 1] == '0')
            {
                nucleotide = "A";
            }
            else if (binaryString[i + 1] == '1')
            {
                nucleotide = "C";
            }
        }
        else if (binaryString[i] == '1')
        {
            if (binaryString[i + 1] == '0')
            {
                nucleotide = "G";
            }
            else if (binaryString[i + 1] == '1')
            {
                nucleotide = "T";
            }
        }

        if (!nucleotide.empty())
        {
            atgcString += nucleotide;
        }
        else
        {
            cerr << "Invalid binary string. Only '0' and '1' characters are allowed." << endl;
            return "";
        }
    }

    return atgcString;
}

vector<string> convertToDNA(const string& binaryStrings)
{
    vector<string> dnaString;

    size_t length = binaryStrings.length();
    size_t numPixels = length / 8;

    for (size_t i = 0; i < numPixels; ++i)
    {
        string binaryStr = binaryStrings.substr(i * 8, 8);
        string atgcString = binaryToATGC(binaryStr);
        dnaString.push_back(atgcString);
    }

    return dnaString;
}
string xorDNASequences(const vector<string>& dnaString, const string& dnaSeq2)
{
    size_t numSequences = dnaString.size();

    if (numSequences == 0 || dnaSeq2.length() == 0)
    {
        cerr << "Error: DNA sequences must not be empty for XOR operation." << endl;
        return "";
    }

    size_t seqLength = dnaString[0].length();

    for (size_t i = 1; i < numSequences; ++i)
    {
        if (dnaString[i].length() != seqLength)
        {
            cerr << "Error: All DNA sequences must have the same length for XOR operation." << endl;
            return "";
        }
    }

    if (seqLength != dnaSeq2.length())
    {
        cerr << "Error: DNA sequences must have the same length for XOR operation." << endl;
        return "";
    }

    string xorResult;
    size_t length = seqLength;

    for (size_t i = 0; i < length; ++i)
    {
        char xorNucleotide = dnaString[0][i];

        for (size_t j = 1; j < numSequences; ++j)
        {
            char nucleotide = dnaString[j][i];

            if (nucleotide == xorNucleotide)
            {
                xorNucleotide = 'A';
            }
            else if (xorNucleotide == 'A' && nucleotide == 'T')
            {
                xorNucleotide = 'T';
            }
            else if (xorNucleotide == 'A' && nucleotide == 'C')
            {
                xorNucleotide = 'C';
            }
            else if (xorNucleotide == 'A' && nucleotide == 'G')
            {
                xorNucleotide = 'G';
            }
            else if (xorNucleotide == 'T' && nucleotide == 'A')
            {
                xorNucleotide = 'T';
            }
            else if (xorNucleotide == 'T' && nucleotide == 'T')
            {
                xorNucleotide = 'A';
            }
            else if (xorNucleotide == 'T' && nucleotide == 'C')
            {
                xorNucleotide = 'G';
            }
            else if (xorNucleotide == 'T' && nucleotide == 'G')
            {
                xorNucleotide = 'C';
            }
            else if (xorNucleotide == 'C' && nucleotide == 'A')
            {
                xorNucleotide = 'C';
            }
            else if (xorNucleotide == 'C' && nucleotide == 'T')
            {
                xorNucleotide = 'G';
            }
            else if (xorNucleotide == 'C' && nucleotide == 'C')
            {
                xorNucleotide = 'A';
            }
            else if (xorNucleotide == 'C' && nucleotide == 'G')
            {
                xorNucleotide = 'T';
            }
            else if (xorNucleotide == 'G' && nucleotide == 'A')
            {
                xorNucleotide = 'G';
            }
            else if (xorNucleotide == 'G' && nucleotide == 'T')
            {
                xorNucleotide = 'C';
            }
            else if (xorNucleotide == 'G' && nucleotide == 'C')
            {
                xorNucleotide = 'T';
            }
            else if (xorNucleotide == 'G' && nucleotide == 'G')
            {
                xorNucleotide = 'A';
            }
        }

        char targetNucleotide = dnaSeq2[i];

        if (xorNucleotide == targetNucleotide)
        {
            xorNucleotide = 'A';
        }
        else if (xorNucleotide == 'A' && targetNucleotide == 'T')
        {
            xorNucleotide = 'T';
        }
        else if (xorNucleotide == 'A' && targetNucleotide == 'C')
        {
            xorNucleotide = 'C';
        }
        else if (xorNucleotide == 'A' && targetNucleotide == 'G')
        {
            xorNucleotide = 'G';
        }
        else if (xorNucleotide == 'T' && targetNucleotide == 'A')
        {
            xorNucleotide = 'T';
        }
        else if (xorNucleotide == 'T' && targetNucleotide == 'T')
        {
            xorNucleotide = 'A';
        }
        else if (xorNucleotide == 'T' && targetNucleotide == 'C')
        {
            xorNucleotide = 'G';
        }
        else if (xorNucleotide == 'T' && targetNucleotide == 'G')
        {
            xorNucleotide = 'C';
        }
        else if (xorNucleotide == 'C' && targetNucleotide == 'A')
        {
            xorNucleotide = 'C';
        }
        else if (xorNucleotide == 'C' && targetNucleotide == 'T')
        {
            xorNucleotide = 'G';
        }
        else if (xorNucleotide == 'C' && targetNucleotide == 'C')
        {
            xorNucleotide = 'A';
        }
        else if (xorNucleotide == 'C' && targetNucleotide == 'G')
        {
            xorNucleotide = 'T';
        }
        else if (xorNucleotide == 'G' && targetNucleotide == 'A')
        {
            xorNucleotide = 'G';
        }
        else if (xorNucleotide == 'G' && targetNucleotide == 'T')
        {
            xorNucleotide = 'C';
        }
        else if (xorNucleotide == 'G' && targetNucleotide == 'C')
        {
            xorNucleotide = 'T';
        }
        else if (xorNucleotide == 'G' && targetNucleotide == 'G')
        {
            xorNucleotide = 'A';
        }

        xorResult += xorNucleotide;
    }

    return xorResult;
}


int main()
{
    cv::Mat image = cv::imread("C:\\Users\\Admin\\Pictures\\dog.jpg", cv::IMREAD_GRAYSCALE);
    if (image.empty())
    {
        cerr << "Unable to read the image." << endl;
        return 1;
    }

    string binaryString = convertToBinary(image);
    // saveBinaryStringToFile(binaryString, "binary.txt");

    vector<string> dnaString = convertToDNA(binaryString);
    string xorSequence = "ATCG";
    for (const string& sequence : dnaString)
    {
        string xorResult = xorDNASequences(vector<string>{sequence}, xorSequence);
        cout << xorResult << " ";
    }   

    // cout << "DNA Strings:" << endl;
    // for (const string& dna : dnaString)
    // {
    //     cout << dna << " ";
    // }

    node* root = NULL;
    for (const string& dna : dnaString)
    {
        Insert(root, dna);
    }

    // cout << "Inorder traversal of the BST: ";
    // traversal_inorder(root);
    // cout << endl;

    // cout << "Preorder traversal of the BST: ";
    // traversal_preorder(root);
    // cout << endl;

    // cout << "Postorder traversal of the BST: ";
    // traversal_postorder(root);
    // cout << endl;

    // cout << "Height of the BST: " << FindHeight(root) << endl;

    // node* minNode = FindMin(root);
    // if (minNode != NULL)
    // {
    //     cout << "Minimum value in the BST: " << minNode->data << endl;
    // }

    // node* maxNode = FindMax(root);
    // if (maxNode != NULL)
    // {
    //     cout << "Maximum value in the BST: " << maxNode->data << endl;
    // }

    // string valueToSearch = "ATGC";
    // bool found = Search(root, valueToSearch);
    // if (found)
    // {
    //     cout << valueToSearch << " found in the BST." << endl;
    // }
    // else
    // {
    //     cout << valueToSearch << " not found in the BST." << endl;
    // }

    // string valueToDelete = "ATTT";
    // root = Delete(root, valueToDelete);
    // cout << "Inorder traversal after deleting " << valueToDelete << ": ";
    // traversal_inorder(root);
    // cout << endl;

    node* balancedTree = BalanceTree(root);
    // cout << "Height of the BST after balanced: " << FindHeight(balancedTree) << endl;
    // cout << "Inorder traversal of the balanced BST: \n";
    // traversal_inorder(balancedTree);
    // cout << endl;
    
    delete balancedTree;

    return 0;
}
