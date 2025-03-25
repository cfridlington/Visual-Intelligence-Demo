//
//  GoogleVisionResponse.swift
//  Visual Intelligence Demo
//
//  Created by Christopher Fridlington on 3/25/25.
//

import Foundation

//{
//  "responses": [
//	{
//	  "webDetection": {
//		"webEntities": [
//		  {
//			"entityId": "/m/02p7_j8",
//			"score": 1.4946,
//			"description": "Rio Carnival"
//		  },
//		  {
//			"entityId": "/m/06gmr",
//			"score": 1.3510317,
//			"description": "Rio de Janeiro"
//		  },
//		  {
//			"entityId": "/m/04cx88",
//			"score": 1.0569,
//			"description": "Brazilian Carnival"
//		  },
//		  {
//			"entityId": "/m/09l9f",
//			"score": 0.91745675,
//			"description": "Carnival"
//		  },
//		  {
//			"entityId": "/t/2dl9bjkz6hhfk",
//			"score": 0.6155
//		  },
//		  {
//			"entityId": "/m/011lf0ff",
//			"score": 0.5456311,
//			"description": "Mardi Gras"
//		  },
//		  {
//			"entityId": "/m/06__c",
//			"score": 0.5356862,
//			"description": "Samba"
//		  },
//		  {
//			"entityId": "/m/063r3",
//			"score": 0.5033,
//			"description": "Parade"
//		  },
//		  {
//			"entityId": "/t/24g_1m01jkvz7",
//			"score": 0.499
//		  },
//		  {
//			"entityId": "/m/03gkl",
//			"score": 0.4745,
//			"description": "Holiday"
//		  }
//		],
//		"fullMatchingImages": [
//		  {
//			"url": "https://i0.wp.com/triniinxisle.com/wp-content/uploads/2019/01/Carnival-Budget.jpg?fit=5184%2C3456&ssl=1"
//		  },
//		  {
//			"url": "https://hispanic-outlook-files.s3.amazonaws.com/uploads/2022/02/22/carnival-in-uruguay-hispanic-outlook-magazine.jpg"
//		  },
//		  {
//			"url": "https://klein-media.s3.amazonaws.com/wp-content/blogs.dir/home/smcsites/public_html/wp-content/blogs.dir/72/files/2020/03/03213339/quinten-de-graaf-KB0Ipylp7dc-unsplash.jpg"
//		  },
//		  {
//			"url": "https://1000lugaresparair.files.wordpress.com/2017/11/quinten-de-graaf-278848.jpg"
//		  },
//		  {
//			"url": "https://get.pxhere.com/photo/people-dance-carnival-festival-sports-samba-event-entertainment-performing-arts-1407044.jpg"
//		  },
//		  {
//			"url": "https://rare-gallery.com/uploads/posts/5389909-woman-friend-festival-colorful-colourful-costume-dressing-up-headdress-selfie-iphone-holding-taking-a-photo-caucasian-retrato-png-images.jpg"
//		  },
//		  {
//			"url": "https://boasvendas.uatt.com.br/wp-content/uploads/2019/02/quinten-de-graaf-278848-unsplash.jpg"
//		  },
//		  {
//			"url": "https://images.unsplash.com/photo-1496767000195-3841ae3f97f4?ixid=M3wxMzcxOTN8MHwxfHNlYXJjaHwxNXx8Y2Fybml2YWx8ZW58MHx8fHwxNzA2NjczMTY5fDA&ixlib=rb-4.0.3&fm=jpg&w=5184&h=3456&fit=max"
//		  },
//		  {
//			"url": "https://cdn.yoo.rs/uploads/249761/images/d7d386bfb691ef91da30c065981dde37d00dc0953d9d9c001734734470."
//		  },
//		  {
//			"url": "https://madefortravellers.com/wp-content/uploads/2018/02/Carnival-Cape-Verde.jpg"
//		  }
//		],
//		"partialMatchingImages": [
//		  {
//			"url": "https://i1.wp.com/prod.kenwoodtravel.net/blog/wp-content/uploads/Add-a-little-bit-of-body-text-5.png?ssl=1"
//		  },
//		  {
//			"url": "https://gizmodo.uol.com.br/wp-content/blogs.dir/8/files/2024/02/carnaval-chuva-970x566.jpg"
//		  },
//		  {
//			"url": "https://tripmydream.cc/travelhub/travel/block_gallery/96/406/default_96406.jpg?"
//		  },
//		  {
//			"url": "https://static.tildacdn.com/tild6162-6337-4862-b736-363366323635/brazil2.jpg"
//		  },
//		  {
//			"url": "https://tripmydream.cc/travelhub/travel/block_gallery/10/0460/default_100460.jpg?"
//		  },
//		  {
//			"url": "https://www.lufficiodeiviaggi.it/wp-content/uploads/2023/08/rio-carnival.jpg"
//		  },
//		  {
//			"url": "https://images.sbs.com.au/dims4/default/5c0079a/2147483647/strip/true/crop/704x396+0+0/resize/1280x720!/quality/90/?url=http%3A%2F%2Fsbs-au-brightspot.s3.amazonaws.com%2Fdrupal%2Fyourlanguage%2Fpublic%2Fsbs_radio_1nextgreek_-_2019-02-28t171853.239.png"
//		  },
//		  {
//			"url": "https://i0.wp.com/triniinxisle.com/wp-content/uploads/2019/01/Carnival-Budget.jpg?resize=350%2C200&ssl=1"
//		  },
//		  {
//			"url": "https://jpimg.com.br/uploads/2025/02/carnaval-300x170.jpg"
//		  },
//		  {
//			"url": "https://pliki.propertynews.pl/i/07/89/43/078943_r2_940.jpg"
//		  }
//		],
//		"pagesWithMatchingImages": [
//		  {
//			"url": "https://www.intrepidtravel.com/eu/brazil/rio-carnival-experience-162026",
//			"pageTitle": "Rio Carnival Experience | Intrepid Travel EU",
//			"partialMatchingImages": [
//			  {
//				"url": "https://www.intrepidtravel.com/v3/assets/blt0de87ff52d9c34a8/blte5973457d49b935e/63c9ad43abb5441cfbc67ede/GGSR-Brazil-rio-carnival-ladies.jpg?branch=prd"
//			  }
//			]
//		  },
//		  {
//			"url": "https://www.intrepidtravel.com/adventures/dancing-in-carnival-parade-in-brazil/",
//			"pageTitle": "Dancing in Rio Carnival reminded me to live in the moment",
//			"partialMatchingImages": [
//			  {
//				"url": "https://www.intrepidtravel.com/adventures/wp-content/uploads/ipf/GGSR.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://www.intrepidtravel.com/us/brazil/rio-carnival-experience-162026",
//			"pageTitle": "Rio Carnival Experience | Intrepid Travel US",
//			"partialMatchingImages": [
//			  {
//				"url": "https://www.intrepidtravel.com/v3/assets/blt0de87ff52d9c34a8/blte5973457d49b935e/63c9ad43abb5441cfbc67ede/GGSR-Brazil-rio-carnival-ladies.jpg?branch=prd"
//			  }
//			]
//		  },
//		  {
//			"url": "https://www.intrepidtravel.com/en/brazil/rio-carnival-experience-162026",
//			"pageTitle": "Rio Carnival Experience | Intrepid Travel EN",
//			"partialMatchingImages": [
//			  {
//				"url": "https://www.intrepidtravel.com/v3/assets/blt0de87ff52d9c34a8/blte5973457d49b935e/63c9ad43abb5441cfbc67ede/GGSR-Brazil-rio-carnival-ladies.jpg?branch=prd"
//			  }
//			]
//		  },
//		  {
//			"url": "https://freelymagazine.com/2020/03/03/what-makes-brazilian-carnival-so-special/",
//			"pageTitle": "What Makes Brazilian Carnival So Special - Freely Magazine",
//			"fullMatchingImages": [
//			  {
//				"url": "https://klein-media.s3.amazonaws.com/wp-content/blogs.dir/home/smcsites/public_html/wp-content/blogs.dir/72/files/2020/03/03213339/quinten-de-graaf-KB0Ipylp7dc-unsplash.jpg"
//			  },
//			  {
//				"url": "https://klein-media.s3.amazonaws.com/wp-content/blogs.dir/home/smcsites/public_html/wp-content/blogs.dir/72/files/2020/03/03213339/quinten-de-graaf-KB0Ipylp7dc-unsplash-1024x683.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://culturalawareness.com/mardigras/",
//			"pageTitle": "Let the Good Times Roll: Mardi Gras and Carnival Celebrations",
//			"fullMatchingImages": [
//			  {
//				"url": "https://culturalawareness.com/wp-content/uploads/2015/02/quinten-de-graaf-278848-scaled.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://tvbrics.com/en/news/what-is-brazilian-carnival-and-how-does-it-happen/",
//			"pageTitle": "What is Brazilian Carnival and how does it happen? - TV BRICS",
//			"partialMatchingImages": [
//			  {
//				"url": "https://tvbrics.com/upload/medialibrary/c29/c294ad2c86cfb712d618afbb3b58dff7.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://traveltomorrow.com/10-interesting-facts-about-rio-de-janeiros-carnival/",
//			"pageTitle": "10 interesting facts about Rio de Janeiro's Carnival - Travel Tomorrow",
//			"fullMatchingImages": [
//			  {
//				"url": "https://traveltomorrow.com/wp-content/uploads/2021/02/carnival-queen-9-quinten-de-graaf-unsplash.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://m.youtube.com/watch?v=moF6PSNIqDQ&pp=ygUOI3NhbWJhbGFwdXJpNGs%3D",
//			"pageTitle": "Carnaval de Rio de Janeiró - Samba Music - 4K UHD - YouTube",
//			"partialMatchingImages": [
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/maxresdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/mqdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/sddefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/hqdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/default.jpg"
//			  }
//			]
//		  },
//		  {
//			"url": "https://www.youtube.com/watch?v=moF6PSNIqDQ",
//			"pageTitle": "Carnaval de Rio de Janeiró - Samba Music - 4K UHD - YouTube",
//			"partialMatchingImages": [
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/maxresdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/mqdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/sddefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/hqdefault.jpg"
//			  },
//			  {
//				"url": "https://i.ytimg.com/vi/moF6PSNIqDQ/default.jpg"
//			  }
//			]
//		  }
//		],
//		"visuallySimilarImages": [
//		  {
//			"url": "https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=1059478179550712"
//		  },
//		  {
//			"url": "https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-2191056161.jpg?c=original"
//		  },
//		  {
//			"url": "https://static.independent.co.uk/2022/06/16/11/CropOver_Lady%20Hands%20Raised.jpg?quality=75&width=640&crop=3%3A2%2Csmart&auto=webp"
//		  },
//		  {
//			"url": "http://static1.squarespace.com/static/5f2bf24111434d59817e6fc4/t/6647731ce834776ec2a20207/1715958556486/HomepageImageHoli.jpg?format=1500w"
//		  },
//		  {
//			"url": "https://www.lavanguardia.com/files/image_449_464/uploads/2020/01/12/5fa9049905f1b.jpeg"
//		  },
//		  {
//			"url": "https://www1.wdr.de/nachrichten/karneval-456~_v-TeaserAufmacher.jpg"
//		  },
//		  {
//			"url": "https://media.licdn.com/dms/image/v2/D4D10AQFEv_Y2o9VEJQ/ads-document-images_800/B4DZVmH_hzGcAk-/1/1741175130268?e=1743638400&v=beta&t=WvPsteXBufMRVY2kln2hVcweBN86eEdWvBHoFoVuCQc"
//		  },
//		  {
//			"url": "https://www.unhcr.org/sites/default/files/legacy-images/626909b43.jpg"
//		  },
//		  {
//			"url": "https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=1070208555147159"
//		  },
//		  {
//			"url": "https://cdn.pixabay.com/photo/2022/09/02/06/40/kids-7426792_1280.jpg"
//		  }
//		],
//		"bestGuessLabels": [
//		  {
//			"label": "brazilian carnival",
//			"languageCode": "en"
//		  }
//		]
//	  }
//	}
//  ]
//}


struct GoogleVisionResponse: Decodable {
	var responses: [GoogleVisionResponseType]
}

struct GoogleVisionResponseType: Decodable {
	var webDetection: GoogleVisionReponseWebDetection
}

struct GoogleVisionReponseWebDetection: Decodable {
	var partialMatchingImages: [GoogleVisionReponseImage]?
	var visuallySimilarImages: [GoogleVisionReponseImage]?
	var pagesWithMatchingImages: [GoogleVisionReponsePageWithMatchingImages]?
}

struct GoogleVisionReponsePageWithMatchingImages: Decodable {
	var pageTitle: String
	var url: URL
	var partialMatchingImages: [GoogleVisionReponseImage]
}

struct GoogleVisionReponseImage: Decodable {
	var url: URL
}
