import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';


class EditProductScreen extends StatefulWidget {

  static const routeName='/Edit-Product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
   bool _isInt=true;
  final _priceFocusNode=FocusNode();
  final _describeFocusNode=FocusNode();
  final _imageurlController=TextEditingController();
  final _imageFocusNode=FocusNode();
  final _formKey=GlobalKey<FormState>();


  var _isLoaded=false;
  var _initValue={
    "title":'',
    "description":'',
    "imageUrl":'',
    "price":''

  };
  var _editProduct=Product(
    id:null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0
  );
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _describeFocusNode.dispose();
    _imageurlController.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }
  
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  void _updateImageUrl(){
    if(_imageurlController.text.isEmpty||
        ( !_imageurlController.text.startsWith('http')&& !_imageurlController.text.startsWith('https'))||
        ( !_imageurlController.text.endsWith(".png")||!_imageurlController.text.endsWith(".jpg"))) {
      return ;
    }
      setState(() {});

  }

  Future<void> _saveForm() async {
    final isVal=_formKey.currentState.validate();
    if(!isVal){
      return;}
    setState(() {
      _isLoaded=true;

    });
    _formKey.currentState.save();
    if(_editProduct.id!=null){
    await Provider.of<Products>(context, listen: false)
        .updateProduct(_editProduct.id,_editProduct);
    }
    else if(_editProduct.id==null)
      try{
     await Provider.of<Products>(context, listen: false)
          .addProduct(_editProduct);
    }

          catch(error){

     await showDialog<Null>(context: context,builder: (ctx)=>
               AlertDialog(
                title: Text('an error occurred '),
                content: Text("something went worng!!"),
                actions: <Widget>[FlatButton(
                  child: Text('close'),
                  onPressed: (){
                  Navigator.of(ctx).pop();

                },)],
              )
            );}


  setState(() {
    _isLoaded=false;

  });
  Navigator.of(context).pop();




//   Navigator.of(context).pop();

}
@override
  void didChangeDependencies() {
    if(_isInt){
      final prodId=ModalRoute.of(context).settings.arguments as String;
      if(prodId!=null){
         _editProduct= Provider.of<Products>(context).findById(prodId);
      }
      _initValue={
        'title':_editProduct.title,
        'description':_editProduct.description,
        'imageUrl':'',
        'price':"${_editProduct.price}",
      };
      _imageurlController.text=_editProduct.imageUrl;
    }
    _isInt=false;
    super.didChangeDependencies();
  }

/////////////////////////////////////main method/////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
          onPressed: (){
            _saveForm();
          },
          color: Colors.redAccent,),
        ],
        title: Text('Edit  Product'),),
      body: _isLoaded?Center(
        child: CircularProgressIndicator(
        backgroundColor:Colors.grey ,
        ),
      ):Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[

            TextFormField(
              initialValue: _initValue['title'],
              validator: (value){
                if(value.isEmpty)
                return 'Please Provide a value';
                return null;
              },
              onSaved: (newValue) =>
              _editProduct=Product(
                title: newValue,
                price: _editProduct.price,
                description: _editProduct.description,
                imageUrl: _editProduct.imageUrl,
                id: _editProduct.id,
                isFavorite: _editProduct.isFavorite

              ),
              onFieldSubmitted: (_){
               FocusScope.of(context).requestFocus(_priceFocusNode);},
               style: TextStyle(color: Theme.of(context).accentColor),
              decoration:InputDecoration(
                labelText: 'Title',),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              initialValue: _initValue['price'],
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter a Price';}
                if(double.parse(value)==null){
                  return 'Please enter a valid number';}
                if(double.parse(value)<= 0){
                  return 'please enter number above zero';}
                return null;
              },
                onSaved: (newValue) =>
              _editProduct=Product(
                  title: _editProduct.title,
                  price:  double.parse(newValue) ,
                  description: _editProduct.description,
                  imageUrl: _editProduct.imageUrl,
                  id: _editProduct.id,
                  isFavorite: _editProduct.isFavorite

              ),
                onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_describeFocusNode);
              },
              focusNode: _priceFocusNode,
              keyboardType: TextInputType.number,
              style: TextStyle(color:  Theme.of(context).accentColor),
              decoration:InputDecoration(
                labelText: 'Price',),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              initialValue: _initValue['description'],
              validator: (value){
                if(value.isEmpty)
                  return 'Please Provide a description';
                if(value.length<10)
                  return 'please write more';
                return null;
              },
              onSaved: (newValue) =>
              _editProduct=Product(
                  title: _editProduct.title,
                  price: _editProduct.price,
                  description: newValue,
                  imageUrl: _editProduct.imageUrl,
                  id: _editProduct.id,
                  isFavorite: _editProduct.isFavorite

              ),
                focusNode: _describeFocusNode,
                style: TextStyle(color:  Theme.of(context).accentColor),
                decoration:InputDecoration(
                labelText: 'Description',),
                maxLines: 3,

            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5,right: 10,left: 2),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.grey),
                    borderRadius: BorderRadius.circular(1)
                  ),
                  child: _imageurlController.text.isEmpty? Text('Enter Url Image'):
                  FittedBox(child: Image.network(_imageurlController.text,fit: BoxFit.cover,),),
                ),
                Expanded(
                  child: TextFormField(

                    validator: (value) {
                      if(value.isEmpty)
                        return 'please enter an image URL';
//                      if(!value.startsWith('http')||!value.startsWith('https'))
//                        return 'please enter Valid URL';
//                      if(!value.endsWith(".png")||!value.endsWith(".jpg"))
//                        return 'enter Valid url';
                      return null;
                    },
                    onSaved: (newValue) =>
                    _editProduct=Product(
                        title: _editProduct.title,
                        price: _editProduct.price,
                        description: _editProduct.description,
                        imageUrl: newValue,
                        id: _editProduct.id,
                        isFavorite: _editProduct.isFavorite),

                    onFieldSubmitted:(imageUrl) => _saveForm()
                    ,
                    focusNode: _imageFocusNode,
                    controller: _imageurlController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    decoration:InputDecoration(

                      labelText: 'image URL',),



                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
