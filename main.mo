  import Map "mo:base/HashMap";
  import Hash "mo:base/Hash";
  import Nat "mo:base/Nat";
  import Iter "mo:base/Iter";
  import Text "mo:base/Text";
  import Time "mo:base/Time";
  import Principal "mo:base/Principal";

actor SocialMedia {

  type Post = {
    author: Principal;
    content: Text;
    timestamp: Time.Time;
  };

  func natHash(n : Nat) : Hash.Hash { 
    Text.hash(Nat.toText(n))
  };

  var posts = Map.HashMap<Nat, Post>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  // Tüm gönderileri getirme işlemi
  public query func getPosts() : async [(Nat, Post)] {
    // Tüm gönderileri döndüren query fonksiyonu
    Iter.toArray(posts.entries()); // HashMap içindeki tüm gönderileri diziye dönüştürüyor
  };

  // Yeni gönderi ekleme işlemi
  public shared (msg) func addPost(content : Text) : async Text {
    // Yeni gönderi ekleyen fonksiyon
    let id = nextId; // Yeni gönderi ID'si oluşturuluyor
    posts.put(id, { author = msg.caller; content = content; timestamp = Time.now() }); // Gönderi HashMap'e ekleniyor
    nextId += 1; // Bir sonraki gönderi ID'si artırılıyor
    "Gönderi başarıyla eklendi. Gönderi ID'si: " # Nat.toText(id); // Sonuç metni döndürülüyor
  };

  // Belirli bir gönderiyi görüntüleme işlemi
  public query func viewPost(id : Nat) : async ?Post {
    // Belirli bir gönderiyi döndüren query fonksiyonu
    posts.get(id); // Gönderiyi ID'si ile getiriyor
  };

  // Tüm gönderileri temizleme işlemi
  public func clearPosts() : async () {
    // Tüm gönderileri temizleyen fonksiyon
    for (key : Nat in posts.keys()) {
      // HashMap içindeki tüm anahtarları alıyor
      ignore posts.remove(key); // Gönderileri temizliyor
    };
  };

  // Gönderileri gösteren işlev
  public query func showPosts() : async Text {
      var output : Text = "\n___Posts___";
      for (post in Iter.to_array(posts.values())) {
          output #= "\n" # post.content;
      }
    };
    output # "\n"
  };

  // Gönderi sayısını döndüren işlev
  public query func getPostCount(): async Nat {
    var count: Nat = 0;
    for (_ in Iter.to_array(posts.keys())) {
      count += 1;
    }
    return count;
  };

}
