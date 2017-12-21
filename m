From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] tpm: Fix the driver cleanup code
Date: Thu, 21 Dec 2017 13:38:53 -0700
Message-ID: <20171221203853.GI20015@ziepe.ca>
References: <1513887422-123222-1-git-send-email-azhar.shaikh@intel.com>
 <20171221202652.GH20015@ziepe.ca>
 <5FFFAD06ADE1CA4381B3F0F7C6AF5828989144@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FFFAD06ADE1CA4381B3F0F7C6AF5828989144@ORSMSX109.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Cc: "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "javierm@redhat.com" <javierm@redhat.com>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 21, 2017 at 08:31:14PM +0000, Shaikh, Azhar wrote:

> Yes I thought about it too. But if some other chip->ops function in
> future, which *might* be in this same case, hence for that
> introduced this flag.

It can't be - the ops struct is constant, can't be modified, and
tpm_tis_core controls what is set. If someone future person meddles in
this then they can fix here to.

Recommend a short comment in the ops clk_enale initializer and call direct?

Jason
