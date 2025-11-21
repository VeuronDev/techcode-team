extends Node


var dialog_chapter_1 = {
	#Narartor
	"1": {
		"text": "Di sebuah desa kecil nan damai, hari dimulai seperti biasa.",
		"name_tag": "narator",
		"path_img": "narator.png"
	},
	"2": {
		#Player
		"text": "Selamat pagi, Kepala Desa. Ada sesuatu yang bisa saya bantu hari ini?",
		"name_tag": "player",
		"path_img": "player.png"
	},
	"3": {
		#Kepala Desa
		"text": "Pagi. Sebenarnya… ada yang janggal belakangan ini.",
		"name_tag": "kepala_desa",
		"path_img": "kepala_desa.png"
	},
	"4": {
		#ibu tua
		"text": "Semalam aku melihat bayangan hitam… bukan manusia.",
		"name_tag": "ibu_tua",
		"path_img": "ibu_tua.png"
	},
	"5": {
		#Kepala Desa
		"text": "Kami butuh kamu untuk memastikan keadaan desa aman.",
		"name_tag": "kepala_desa",
		"path_img": "kepala_desa.png"
	},
	"6": {
		#player
		"text": "Tenang saja, aku akan cek sekitar—",
		"name_tag": "player",
		"path_img": "player.png"
	},
}

var dialog_chapter_2 = {
	#KUro
	"1": {
		"text": "Teriakan keras terdengar dari arah barat desa!",
		"name_tag": "narator",
		"path_img": "narator.png"
	},
	"2": {
		"text": "Apa itu?! Suara warga!",
		"name_tag": "name",
		"path_img": "res://assests/characters/player/sunnyside_world_chatacter_anim_v0.png"
	},
	"3": {
		"text": "TIDAAK! Goblin dan Skeleton! MEREKA MENYERANG!",
		"name_tag": "kepala_desa",
		"path_img": "kepala_desa.png"
	},
	"4": {
		"text": "GYAHAHA! Ini desa milik kami sekarang!",
		"name_tag": "Bos Goblin ",
		"path_img": "Bos_Goblin.png"
	},
	"5": {
		"text": "Tangkap semua warga… bawa ke dungeon.",
		"name_tag": "Bos Skeleton",
		"path_img": "Bos_Skeleton.png"
	},
	"6": {
		"text": "Berhenti! Lepaskan mereka",
		"name_tag": "Player",
		"path_img": "res://assests/characters/player/sunnyside_world_chatacter_anim_v0.png"
	},
	"7": {
		"text": "Coba hentikan kami kalau berani, manusia lemah!",
		"name_tag": "Bos Goblin",
		"path_img": "Bos_Goblin.png"
	}
}
var dialog_chapter_3 = {
	#Narartor
	"1": {
		"text": "Goblin dan Skeleton menyeret beberapa warga masuk ke portal menuju dungeon.",
		"name_tag": "narator",
		"path_img": "narator.png"
	},
	"2": {
		#Pkepala desa
		"text": "Player… kami mohon. Selamatkan warga kami.",
		"name_tag": "kepala_desa",
		"path_img": "kepala_desa.png"
	},
	"3": {
		#player
		"text": "Aku janji… aku akan bawa mereka kembali.",
		"name_tag": "player",
		"path_img": "player.png"
	},
}
var dialog_chapter_4 = {
	#kuro
	"1": {
		"text": "Kau datang juga, manusia",
		"name_tag": "Bos Goblin",
		"path_img": "Bos_Goblin.png"
	},
	"2": {
		"text": "Mana warga kami!",
		"name_tag": "Player",
		"path_img": "res://assests/characters/player/sunnyside_world_chatacter_anim_v0.png"
	},
	"3": {
		"text": "Jika ingin mereka kembali… kalahkan kami dulu.",
		"name_tag": "Bos Skeleton",
		"path_img": "Bos_Skeleton.png"
	},
	"4": {
		"text": "Baik. Aku akan hadapi kalian. Satu per satu.",
		"name_tag": "Plyaer",
		"path_img": "res://assests/characters/player/sunnyside_world_chatacter_anim_v0.png"
	},
}
var dialog_chapter_wave_final = {
	#goblin leader
	"1": {
		"text": "Kau kuat juga… tapi ini akhirnya!",
		"name_tag": "goblin_leader",
		"path_img": "goblin_leader.png"
	},
	"2": {
		#skeleton captain
		"text": "Kami tidak akan biarkanmu membawa mereka pergi!",
		"name_tag": "skeleton_captain",
		"path_img": "skeleton_captain.png"
	},
	"3": {
		#player
		"text": "Aku tidak akan menyerah. Demi desa!.",
		"name_tag": "player",
		"path_img": "player.png"
	},
}
var dialog_chapter_5_Kemenangan = {
	#kuro
	"1": {
		"text": "Ugh… mustahil… manusia sepertimu…",
		"name_tag": "Bos Goblin",
		"path_img": "Bos_Goblin.png"
	},
	"2": {
		"text": "Kekuatan… macam apa… ini…",
		"name_tag": "Bos Skeleton",
		"path_img": "Bos_Skeleton.png"
	},
	"3": {
		"text": "Ini kekuatan dari mereka yang ingin kulindungi.”",
		"name_tag": "Player",
		"path_img": "kepala_desa.png"
	},
	"4": {
		"text": "Kedua bos runtuh menjadi debu. Kunci penjara warga jatuh.",
		"name_tag": "narator",
		"path_img": "narator.png"
	}
}
var dialog_chapter_6 = {
	#player
	"1": {
		"text": "Semua orang baik-baik saja?",
		"name_tag": "player",
		"path_img": "player.png"
	},
	"2": {
		#warga 1
		"text": "Terima kasih! Kami kira… kami tidak akan selamat.",
		"name_tag": "warga_1",
		"path_img": "warga_1.png"
	},
	"3": {
		#warga 2
		"text": "Kau pahlawan kami!",
		"name_tag": "warga_2",
		"path_img": "warga_2.png"
	},
	"4": {
		#Kepala Desa
		"text": "Atas nama seluruh desa… kami berterima kasih padamu.",
		"name_tag": "kepala_desa",
		"path_img": "kepala_desa.png"
	},
	"5": {
		#ibu tua
		"text": "Kau membawa harapan kembali ke desa ini, anak muda.",
		"name_tag": "ibu_tua",
		"path_img": "ibu_tua.png"
	},
	"6": {
		#player
		"text": "Aku hanya melakukan apa yang harus kulakukan.",
		"name_tag": "player",
		"path_img": "player.png"
	},
}
var dialog_chapter_7_ending = {
	#kuro
	"1": {
		"text": "Invasi berakhir. Desa Sunny Day kembali damai.",
		"name_tag": "narator",
		"path_img": "narator.png"
	},
	"2": {
		"text": "Semoga kedamaian ini bertahan… dan kau tetap ada bersama kami.",
		"name_tag": "Kepala desa",
		"path_img": "kepala_desa.png"
	},
	"3": {
		"text": "Selama desa ini butuhku… aku akan selalu siap.",
		"name_tag": "Player",
		"path_tag": "res://assests/characters/player/sunnyside_world_chatacter_anim_v0.png",
	}
}
