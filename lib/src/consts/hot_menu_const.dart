// link จะโหลดใหม่ทุกครั้งที่เปิดแอปใหม่
// หากมีเมนู Config เพิ่มใหม่ หลังจากติดตั้งแอปไปแล้ว User ต้องไปเพิ่มเมนูใหม่ที่หน้า Favourite Menu เอง
const mHotMenuConfig = {
  'project': {
    'titleText_en': 'Project',
    'titleText_th': 'โครงการ',
    'iconAsset': 'assets/icons/Projects.svg',
    'link': '/projects',
    'mandatory': true,
  },
  'promotion': {
    'titleText_en': 'Promotion',
    'titleText_th': 'โปรโมชั่น',
    'iconAsset': 'assets/icons/Campaign.svg',
    'link': '/promotions',
    'mandatory': false,
  },
  'favorite': {
    'titleText_en': 'Favorite',
    'titleText_th': 'ชื่นชอบ',
    'iconAsset': 'assets/icons/Fav.svg',
    'link': '/favourites',
    'mandatory': false,
  },
  'news': {
    'titleText_en': 'News',
    'titleText_th': 'ข่าวสาร',
    'iconAsset': 'assets/icons/news.svg',
    'link': '',
    'mandatory': false,
  }
};

// ระบุเมนูเริ่มต้นเมื่อติดตั้งแอปครั้งแรก
// ต้องไม่เกินจำนวนที่กำหนดใน mHotMenuRow
const mDefaultMenuConfig = [
  'project',
  'promotion',
  'favorite',
  'news',
];
