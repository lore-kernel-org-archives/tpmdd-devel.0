From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 4/4] tpm/vtpm: fix kdoc warnings
Date: Sat, 3 Dec 2016 18:17:17 +0200
Message-ID: <20161203161717.4s5grkihvc3pckci@intel.com>
References: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
 <1479895454-15076-5-git-send-email-tomas.winkler@intel.com>
 <20161203153604.pt5rnnhvovudku6r@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161203153604.pt5rnnhvovudku6r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Dec 03, 2016 at 05:36:04PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 23, 2016 at 12:04:14PM +0200, Tomas Winkler wrote:
> > Use corret kdoc format for function description and eliminate warning
> > of type:
> > 
> > tpm_ibmvtpm.c:66: warning: No description found for parameter 'count'
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

... in the sense that the changes do not break the compilation and do
not produce sparse or cocciheck errors. I guess that should be enough
for these documentation changes.

/Jarkko
